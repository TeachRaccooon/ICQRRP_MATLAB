function[A_cpy, Q, R, P] = rqrcp_chol_new()

    %A = randn(1000, 250);
    %A = [A, A, A, A];
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

    Q = eye(m, m);
    R = zeros(m, n);
    P = eye(n, n);
    
   
    for j = 1:(k / b_sz)

        sz = size(A, 1);

        % Begin by sketching in an embedding regeme
        A_sk = randn(d, sz)  * A;

        % Get the pivots and the preconditioner
        % Add/remove '0' to control the pivots format
        [~, R_sk, J] = qr(A_sk);

        % Cut the size of R_sk
        R_sk = R_sk(1: b_sz, 1: b_sz);

        % Permute the full R factor
        if j ~= 1
            R = piv_swap(R, J);
        end

        % computing A_pre in a standard manner
        A_pre = A * J(:, 1:b_sz) / R_sk;
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
        R12 = Q_full(:, 1:b_sz)' * A * J(:, b_sz + 1:end);

        % Updating matrix A
        A = Q_full(:, b_sz + 1:end)' * A * J(:, b_sz + 1:end);

        % Update Q, P. Below is an explanation / old strategy
        Q(:, (j - 1) * b_sz + 1 : end) = Q(:, (j - 1) * b_sz + 1 : end) * Q_full;

        disp(J)
        disp(P)

        P(:, (j - 1) * b_sz + 1 : end) = P(:, (j - 1) * b_sz + 1 : end) * J;

        R1 = [R11 R12];

        R((j - 1) * b_sz + 1: j * b_sz, (j - 1) * b_sz + 1: end) = R1;

        disp(R)

        disp("BREAK")

    end
    
    % We only need b_sz * j rows/cols for the final factorization
    % Below are identical up to machine precision
    disp(P)
    nrm = norm(A_cpy * P - Q(:, 1:b_sz * j) * R(1:b_sz * j, :))
    nrm = norm(A_cpy * P - Q * R)

end

function[A] = piv_swap(A, J)
    sz = size(J, 1);

    Buf = A(:, end-sz + 1:end);

    Buf = Buf * J;
    A(:, end-sz + 1:end) = Buf;
end

function[Q, R] = CholQR(A)
    
    G = A' * A;
    R = chol(G);
    Q = A / R;

end


        %{
        % This is the old strategy for defining Q at a given iteration.

        QI = eye(m, m);
        PI = eye(n, n);

        QI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = Q_full;
        PI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = J;
        disp("QI")
        disp(QI)

        disp("Q cut")    
        disp(Q * QI(:, 1: b_sz * j))

        disp("What we find during a given iteration. We only need the first b_sz columns.")
        disp(Q(:, (j - 1) * b_sz + 1 : end) * QI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end))

        disp("Attempt to get the first b_sz columns.")
        disp(Q(:, (j - 1) * b_sz + 1 : end) * QI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : j * b_sz))

        % The above empirically shows that we DO need the full Q all the way up until the final iteration.

        Q = Q * QI;
        P = P * PI;

        disp("Q full")
        disp(Q)
        %}