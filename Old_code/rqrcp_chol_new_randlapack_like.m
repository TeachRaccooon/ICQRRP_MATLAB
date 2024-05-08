function[A_cpy, Q, R, P] = rqrcp_chol_new_randlapack_like()
%{
    %A = randn(1000, 250);
    %A = [A, A, A, A];
    %k = 250;
    %d = 1000;
    %b_sz = 50;

    A = randn(12, 12);
    k = 12;
    d = 12;
    b_sz = 3;
%}

    A = [	   0.14655763283932157770,  -0.09831821885091551749,  -0.01035576819310800312,  -0.09706748771980508450,   0.50546297102908321897,
	  -0.16776825739571363250,   0.16667718045064366938,  -0.12512260679501335803,  -0.18642693754303307774,   0.21175470125293041623,
	  -0.17423407104128091349,  -0.36780022661387895555,  -0.26462035492968788430,  -0.05475465580530114451,   0.15040676893401039305,
	   0.49021766274738004521,  -0.10521314109043010399,  -0.04979496231330853007,  -0.03375015137478216964,  -0.08759039367403555210,
	  -0.25250223399610766117,  -0.32608619320749776538,  -0.03755197045293956482,   0.09847006683515535652,   0.02488691986853720783,
	  -0.19564465698365651747,   0.00189227691102612089,   0.29271910538968898274,   0.53529830109642040359,   0.13037705056532178371,
	  -0.08220159709287555572,  -0.25987274778025393207,  -0.60627483735347798000,  -0.19087269174383905690,  -0.19796239491562170332,
	  -0.02573812420145497187,   0.04616925405341791577,  -0.26776579661987803815,  -0.01522904738934095607,  -0.00854061119101588717,
	  -0.25793257775856504033,   0.27041315481643696250,   0.14531434191118619559,  -0.24479542288436437203,  -0.10828612702869788720,
	   0.14285792525589394164,  -0.42421248878781370184,   0.53274047172433414143,  -0.30301797160893745309,   0.13202530354088959363,];

    k = 5;
    b_sz = 5;
    d = 5;

    A_cpy = A;

    A = A_cpy;
    [m, n] = size(A);

    Q = eye(m, m);
    R = zeros(m, n);
    P = eye(n, n);
    P_vector = zeros(1, n);
   
    for j = 1:(k / b_sz)

        % sz decreases by block_sz
        rows = m - b_sz * (j - 1);
        cols = n - b_sz * (j - 1);
        size(A)

        % Begin by sketching in an embedding regeme
        A_sk = randn(d, rows)  * A;

        A_sk = [	  -0.29071250633364054128,   1.11928329492412226287,  -0.19899300464437230662,  -0.47262999817104139888,   0.03902861503364285500,
	  -0.40071756830649318815,  -0.01975000595383236135,   0.40198595358507022146,   0.37340181155827173454,  -0.24968415664436804935,
	  -0.85827512316158283134,  -0.79364451208422970296,   0.94672315845556798131,   0.14349685274211881891,  -0.16751244395800624076,
	  -0.42586162700093399547,  -0.25297782554073933170,  -0.56683564323327750856,  -0.25419002808886198563,   0.39509096978749702611,
	   0.02573812420145497187,  -0.04616925405341791577,   0.26776579661987803815,   0.01522904738934095607,   0.00854061119101588717,];

        % Get the pivots and the preconditioner
        % Add/remove '0' to control the pivots format
        [~, R_sk, J] = qr(A_sk, 0);

        if j ~= 1
            % We will want to easily pivot trailing sets of columns of some
            % matrices here. To do that, we will need to "complete" the set of
            % pivots. For that, we declare the "identity pivot vector."
            J_full = 1:n;
            J_full(:, cols - sz + 1:end) = J + (cols - sz);

            % Immediately permute the trailing columns of the full R factor
            %R(:, (j - 1) * b_sz + 1 : end) = R(:, (j - 1) * b_sz + 1 : end) * I(:, J);
            R = R(:, J_full);
        end

        % Cut the size of R_sk
        R_sk = R_sk(1: b_sz, 1: b_sz);

        % Pivot matrix A in advance, like in RandLAPACK
        % But we need the full pivoted matrix
        A_piv = A(:, J);

        % computing A_pre in a standard manner
        A_pre = A_piv(:, 1:b_sz) / R_sk;
        % Cholesky QR step
        [Q_econ, ~] = CholQR(A_pre);
        % We use this to restore full Q from QR on A_pre
        [Q_full, ~] = qr(Q_econ);
        
        %Restore full R from QR on A_pre
        % This R is the same as R_econ up to the signs on the main
        % diagonal, so just adding zeros won't cut it.
        R11_full = Q_full' * A_pre;

        % Computing subportions on an R-factor
        R11 = R11_full(1:b_sz, :) * R_sk;
        R12 = Q_full(:, 1:b_sz)' * A_piv(:, b_sz + 1:end);

        % Updating matrix A
        A = Q_full(:, b_sz + 1:end)' * A_piv(:, b_sz + 1:end);

        % Update Q, P. Below is an explanation / old strategy
        Q(:, (j - 1) * b_sz + 1 : end) = Q(:, (j - 1) * b_sz + 1 : end) * Q_full;

        % Pivot only the last "piv_size" columns of J
        if j == 1
            P_vector = J;
            I = eye(cols, cols);
            P = I(:, J);
        else
            P_vector = P_vector(:, J_full);
            P = P(:, J_full);
            %P(:, (j - 1) * b_sz + 1 : end) = P(:, (j - 1) * b_sz + 1 : end) * I(:, J);
        end

        % Update the R factor
        R1 = [R11 R12];
        R((j - 1) * b_sz + 1: j * b_sz, (j - 1) * b_sz + 1: end) = R1
    end
    
    % We only need b_sz * j rows/cols for the final factorization
    % Below are identical up to machine precision
    nrm = norm(A_cpy * P - Q(:, 1:b_sz * j) * R(1:b_sz * j, :))
    nrm = norm(A_cpy * P - Q * R)
    nrm = norm(A_cpy(:, P_vector) - Q * R)

end

function[Q, R] = CholQR(A)
    
    G = A' * A;
    R = chol(G);
    Q = A / R;

end