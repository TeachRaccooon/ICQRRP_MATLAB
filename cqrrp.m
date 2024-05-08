function[A_cpy, Q, R, P] = cqrrp()

    A = randn(8, 8);

    A = [0.29895678162574768066,   0.18415980041027069092,  -0.34196627140045166016,  -0.63713198900222778320,   0.96594864130020141602,  -0.53526514768600463867,  -1.31693565845489501953,   0.52420413494110107422,
	  -0.40633684396743774414,   1.49947345256805419922,   0.78396123647689819336,  -0.14826019108295440674,   0.00531004043295979500,   0.34763002395629882812,  -1.01287293434143066406,   2.53039216995239257812,
	  -0.99769562482833862305,   1.24989056587219238281,  -0.14807499945163726807,  -2.27646946907043457031,  -0.21214857697486877441,   0.60648500919342041016,   0.23717460036277770996,  -0.26855477690696716309,
	  -0.08980366587638854980,   1.02153873443603515625,   0.38912740349769592285,   1.24468016624450683594,   0.54299324750900268555,   0.34046339988708496094,   0.19744168221950531006,  -2.30575060844421386719,
	  -0.24734789133071899414,  -1.28967857360839843750,   0.82217615842819213867,  -2.11300182342529296875,  -1.00800836086273193359,  -1.85156345367431640625,   0.81349641084671020508,  -0.36917880177497863770,
	   1.40375840663909912109,   0.30849137902259826660,  -2.54815745353698730469,  -1.35996842384338378906,  -1.59961032867431640625,  -1.76625144481658935547,  -0.63077670335769653320,  -0.31991168856620788574,
	  -2.40918231010437011719,  -0.79744011163711547852,  -1.26158154010772705078,  -1.23696327209472656250,  -0.69095790386199951172,  -0.28298473358154296875,   0.46657323837280273438,  -2.88487744331359863281,
	  -0.88568437099456787109,  -1.03299450874328613281,  -0.69069576263427734375,  -0.23535305261611938477,   2.00509524345397949219,   0.55830675363540649414,  -0.67680275440216064453,  -0.71272581815719604492,
];

    d_over = 2;
    b_sz = 3;

    A_cpy = A;

    [m, n] = size(A);

    Q = zeros(m, m);
    R = zeros(m, n);
    P_vector = zeros(1, n);
   
    norm_A = norm(A, 'fro');
    norm_R = 0;
    approximation_errors = [];

    curr_sz = 0;

    % Begin by sketching in a sampling regeme
    d = d_over * b_sz;
    B = randn(d, m)  * A;

    B = [	   3.45162749290466308594,  -0.24973370134830474854,  -1.07564952969551086426,   1.61641313135623931885,   2.11661161808297038078,   0.91118961572647094727,  -1.78157405555248260498,   3.55361881852149963379,
	   6.35000544786453247070,   0.67924055457115173340,  -2.05394254624843597412,   4.65007938444614410400,  -1.69890077086165547371,  -1.14412504434585571289,  -0.45834526419639587402,   1.38503298163414001465,
	   0.27046847343444824219,  -1.73108597099781036377,   3.33976708352565765381,   3.26424276828765869141,  -1.70227822661399841309,   0.79626142978668212891,   2.18989883363246917725,   3.08273875713348388672,
];

    for j = 1:ceil(min(m, n) / b_sz)
        % rows, cols decreases by block_sz
        rows = m - b_sz * (j - 1);
        cols = n - b_sz * (j - 1);

        %curr_sz = (j - 1) * b_sz;
        b_sz = min(b_sz, min(m, n) - curr_sz);

        % Get the pivots and the preconditioner
        %[~, S, J] = qr(B, 'vector');
         [~, ~, J] = lu(B', 'vector');
         %J_buf = 1:cols;
         %cutoff = min(size(B, 1), size(B, 2));
         %J(cutoff+1:end) = J_buf(cutoff+1:end);

         
         disp(J)
         if j == 1
            %J = [8, 4, 5, 8, 5, 8];
         elseif j == 2
            %J = [3, 5, 5, 5, 5];
         elseif j == 3
            %J = [1, 2]; 
         end

         B = B(:, J);
         [~, S] = qr(B);

        if j ~= 1
            % We will want to easily pivot trailing sets of columns of some
            % matrices here. To do that, we will need to "complete" the set of
            % pivots. For that, we declare the "identity pivot vector."

            % Immediately permute the trailing columns of the full R factor
            
            % This is easier to implement in RandLAPACK
            R_to_permute = R(:, curr_sz + 1:end);
            R(:, curr_sz + 1:end) =  R_to_permute(:, J);
        end

        % Cut the size of R_sk
        R_sk = S(1: b_sz, 1: b_sz);
        fprintf("RANK OF R_SK IS %d\n", rank(R_sk));

        % Pivot matrix A in advance, like in RandLAPACK
        % But we need the full pivoted matrix
        A_piv = A(:, J);

        % computing A_pre in a standard manner
        A_pre = A_piv(:, 1:b_sz) / R_sk;
        % Cholesky QR step
        [Q_econ, R_econ] = CholQR(A_pre);
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

        % Update Q, Pivots
        % Pivot only the last "piv_size" columns of J
        if j == 1
            P_vector = J;
            Q = Q_full;
        else
            % This is a simple way of explaining what we're doing
            %P_vector = P_vector(:, J_full);

            % This is easier to implement in RandLAPACK
            P_vector_to_permute = P_vector(:, (curr_sz + 1):end);
            P_vector(:, curr_sz + 1:end) =  P_vector_to_permute(:, J);

            % In the final factorization, we only need the first "b_sz * j"
            % columns. But in order to compute the j+1st Q at iteration Q,
            % we need to have access to a full Q factor
            Q(:, curr_sz + 1 : end) = Q(:, curr_sz + 1 : end) * Q_full;
        end

        % Update the R factor
        R1 = [R11 R12];
        R(curr_sz + 1: curr_sz + b_sz, curr_sz + 1: end) = R1;
        
        curr_sz = curr_sz + b_sz;


        % VERY FIRST ITERATION

        B1 = S(1:b_sz, b_sz+1:end) - S(1:b_sz, 1:b_sz)*inv(R11)*R12;
        B2 = S(b_sz+1:end, b_sz+1:end);

        B = [B1; B2];
        % Now, B is of size b_sz + oversampl by n - b_sz
        % Then, R from QRCP is of size n - b_sz by n - b_sz if we're doing
        % econ.
        % If we're doing regular QR, R will be b_sz + oversampl by n - b_sz
        % So it wil be the case that onlt the number of columns is
        % decreasing


        norm_R = hypot(norm_R, norm(R1, 'fro'));
        approximation_errors = [approximation_errors, sqrt(abs(norm_A - norm_R) * (norm_A + norm_R)) / norm_A]; 
        

        fprintf("Done with iteration %d\n", j);
    end
    plot(approximation_errors);

    % We only need b_sz * j rows/cols for the final factorization
    % Below are identical up to machine precision
    nrm = norm(A_cpy(:, P_vector) - Q(:, 1:b_sz * j) * R(1:b_sz * j, :), 'fro') / norm(A_cpy(:, P_vector), 'fro') % THIS FORMULA IS EXPECTED TO NOT WORK HERE
    nrm = norm(A_cpy(:, P_vector) - Q * R) / norm(A_cpy(:, P_vector), 'fro')
end

function[Q, R] = CholQR(A)
    G = A' * A;
    R = chol(G);
    Q = A / R;
end

function[] = col_swap(k, A, J)

J_cpy = J;
for i = 1:k
    j = J_cpy(1, i);
    swap(A(:, i), (A(:, j)));

    for l = i:k
        if J_cpy(1, l) == i
            J_cpy(1, l) = j;
            break;
        end
    end
    J_cpy(1, i) = i;
end
end