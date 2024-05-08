function[] = check(A, d, k)
    
    [m, n] = size(A);
    S = randn(d, m);
    A_hat = S * A;
    
    [Q_hat, R_hat, J] = qr(A_hat, 0);
    R_hat_sp = eye(k, n) * R_hat * eye(n, k);
    A_sp_pre = A(:, J(:, 1:k)) * inv(R_hat_sp);
    [Q, R_sp] = qr(A_sp_pre, 0);
    R = R_sp * eye(k, n) * R_hat;

    %disp(norm(A(:, J(:, 1:k)) - Q * R));
    I = eye(n, n);
    disp(J(:, 1:k))
    disp(I(:, J(:, 1:k)))
    %disp(A * I(:, J(:, 1:k)) - Q * R)
    %disp(A - Q * eye(k, n) * R_hat)
    disp(Q' * A(:, J) - R)
    %disp(norm(A - Q * R));
    disp(norm(A - (A(:, J(:, 1:k)) * inv(eye(k, n) * R_hat * eye(n, k)) * eye(k, n) * R_hat(:, J))));
    disp(norm(A(:, J) - (A(:, J(:, 1:k)) * inv(eye(k, n) * R_hat * eye(n, k)) * eye(k, n) * R_hat)));
    disp(inv(eye(k, n) * R_hat * eye(n, k)) * eye(k, n) * R_hat)
    %disp(J)
end