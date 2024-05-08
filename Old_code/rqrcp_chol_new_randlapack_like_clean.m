function[A_cpy, Q, R, P] = rqrcp_chol_new_randlapack_like_clean()

    %A = randn(1000, 250);
    %A = [A, A, A];
    %k = 250;
    %d = 1000;
    %b_sz = 50;

    A = randn(10, 6);

    k = 6;
    d = 6;
    b_sz = 3;

    A_cpy = A;

    A = A_cpy;
    [m, n] = size(A);

    Q = zeros(m, m);
    R = zeros(m, n);
    P_vector = zeros(1, n);
    
    for j = 1:(k / b_sz)
        % sz decreases by block_sz
        sz = m - b_sz * (j - 1)
        cols = n - b_sz * (j - 1)

        % Begin by sketching in an embedding regeme
        A_sk = randn(d, sz)  * A;

        % Get the pivots and the preconditioner
        % Add/remove '0' to control the pivots format
        [~, R_sk, J] = qr(A_sk, 0);

        if j ~= 1
            % We will want to easily pivot trailing sets of columns of some
            % matrices here. To do that, we will need to "complete" the set of
            % pivots. For that, we declare the "identity pivot vector."

            % Immediately permute the trailing columns of the full R factor
            
            % This is a simple way of explaining what we're doing
            %J_full = 1:n;
            %J_full(:, n - sz + 1:end) = J + (n - sz);
            %R = R(:, J_full);
            
            % This is easier to implement in RandLAPACK
            R_to_permute = R(:, (j - 1) * b_sz + 1:end);
            R(:, (j - 1) * b_sz + 1:end) =  R_to_permute(:, J);
        end

        % Cut the size of R_sk
        R_sk = R_sk(1: b_sz, 1: b_sz);

        % Pivot matrix A in advance, like in RandLAPACK
        % But we need the full pivoted matrix
        A_piv = A(:, J)

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

        % Update Q, Pivots
        % Pivot only the last "piv_size" columns of J
        if j == 1
            P_vector = J;
            Q = Q_full;
        else
            % This is a simple way of explaining what we're doing
            %P_vector = P_vector(:, J_full);

            % This is easier to implement in RandLAPACK
            P_vector_to_permute = P_vector(:, ((j - 1) * b_sz + 1):end);
            P_vector(:, (j - 1) * b_sz + 1:end) =  P_vector_to_permute(:, J);

            % In the final factorization, we only need the first "b_sz * j"
            % columns. But in order to compute the j+1st Q at iteration Q,
            % we need to have access to a full Q factor
            Q(:, (j - 1) * b_sz + 1 : end) = Q(:, (j - 1) * b_sz + 1 : end) * Q_full;
        end

        % Update the R factor
        R1 = [R11 R12];
        R((j - 1) * b_sz + 1: j * b_sz, (j - 1) * b_sz + 1: end) = R1;
        

        A
        Q
        R
        P_vector

        %break;
    end
    
    % We only need b_sz * j rows/cols for the final factorization
    % Below are identical up to machine precision
    nrm = norm(A_cpy(:, P_vector) - Q(:, 1:b_sz * j) * R(1:b_sz * j, :), 'fro') / norm(A_cpy(:, P_vector), 'fro')
    nrm = norm(A_cpy(:, P_vector) - Q * R) / norm(A_cpy(:, P_vector), 'fro')

end

function[Q, R] = CholQR(A)
    G = A' * A;
    R = chol(G);
    Q = A / R;
end