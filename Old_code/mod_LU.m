function[L, U, S] = mod_LU(Q)

    Q_buf = Q;

    [m, n] = size(Q);
    S = zeros(m, n);
    
    disp(Q)
    for i = 1:(n)
        disp(i)
        S(i, i) = -sign(Q(i, i));
        if sign(Q(i, i)) == 0
            S(i, i) = 1;
        end

        Q(i, i) = Q(i, i) - S(i, i);

        Q(i+1:m, i) = (1 / Q(i, i)) * Q(i+1:m, i); 

        disp("BEFORE")
        disp(Q)

        disp(Q(i+1:m, i))
        disp(Q(i, i+1:n))
        disp(Q(i+1:m, i) * Q(i, i+1:n))

        Q(i + 1:m, i+1:n) = Q(i+1:m, i+1:n) - Q(i+1:m, i) * Q(i, i+1:n);
    
        disp("AFTER")
        disp(Q)
    end


    L = tril(Q, -1) + eye(m, n);
    U = triu(Q);
    U = U(1:n, :);

end