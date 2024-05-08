
% Clean version of the working code
% On output, approximation is A - Q * R
function[Q, R, J] = rqrcp(A, k, b_sz)
    [m, n] = size(A);
    Q = eye(m, m);
    R = zeros(m, n);
    P = eye(n, n);


    for j = 1:(k / b_sz)

        sz = size(A, 1);

        S = randn(k, sz);
        A_hat = S  * A;

        [~, ~, J] = qr(A_hat);

        if j ~= 1
            R = piv_swap(R, J);
        end

        [Q_, R11_full] = qr(A * J(:, 1:b_sz));

        R11 = R11_full(1:b_sz, :);

        R12 = Q_(:, 1:b_sz)' * A * J(:, b_sz + 1:end);

        A = Q_(:, b_sz + 1:end)' * A * J(:, b_sz + 1:end);

        QI = eye(m, m);
        PI = eye(n, n);

        QI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = Q_;
        PI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = J;

        Q = Q * QI;
        P = P * PI;
        
        R1 = [R11 R12];

        R((j - 1) * b_sz + 1: j * b_sz, (j - 1) * b_sz + 1: end) = R1;
    end

end


function[A] = piv_swap(A, J)
    sz = size(J, 1);

    Buf = A(:, end-sz + 1:end);

    Buf = Buf * J;
    A(:, end-sz + 1:end) = Buf;
end