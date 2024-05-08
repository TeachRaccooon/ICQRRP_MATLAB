function[A_cpy, Q, R, P] = experiment()

    m = 5;
    n = 3;
    A = randn(m, n);
    


    cond(A)

    [Q_full, R_full] = simple(A, m, n);
    norm(A - Q_full * R_full) / norm(A)

    delta = A - Q_full * R_full;
    round(delta, 2)

    %[Q_full, R_full] = complex(A, m, n);
    %norm(A - Q_full * R_full) / norm(A)
end


function[Q_full, R_full] = simple(A, m, n)
    [Q_econ, R_econ] = qr(A, "econ");
    q_sign = [-1 * diag(sign(diag(Q_econ))); zeros(m - n, n)];

    R_full = q_sign * R_econ;
    [L, U] = lu(A - R_full);

    T = -1.0 * ((U / R_econ) / L(1:n, :)');

    Q_full = [q_sign, [[zeros(n, m-n)]; eye(m-n, m-n)]] - L * T * L';
    %Q_full' * Q_full
    %Q_full * Q_full'
end


function[Q_full, R_full] = complex(A, m, n)
    G = A' * A;
    R_econ = chol(G);
    Q_econ = A / R_econ;

    %[Q_econ, R_econ] = qr(A, "econ");
    q_sign = [-1 * diag(sign(diag(Q_econ))); zeros(m - n, n)];

    R_full = q_sign * R_econ;
    [L, U] = lu(A - R_full);

    T = -1.0 * ((U / R_econ) / L(1:n, :)');

    Q_full = [q_sign, [[zeros(n, m-n)]; eye(m-n, m-n)]] - L * T * L';
    %Q_full' * Q_full
    %Q_full * Q_full'
end