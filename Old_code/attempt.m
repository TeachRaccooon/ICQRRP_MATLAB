function[] = attempt()
    sum1 = 0;
    sum2 = 0;

    for i = 1:5
        A = randn(10000, 5000);
    
        tic;
        [Q, R] = qr(A);
        sum1 = sum1 + toc;
    
        tic;
        [Q, R] = CholQR(A);
        %Q = qr(Q);
        %R = Q' * A;
        sum2 = sum2 + toc;
    end

    disp(sum1/5)
    disp(sum2/5)
end

function[Q, R] = CholQR(A)
    
    G = A' * A;
    R = chol(G);
    Q = A / R;

end