function[Q, R, J] = cholqrcp_nonblocked(A, d, k)
    
    A_cpy = A;
    [m, n] = size(A);
    S = randn(d, m);
    A_hat = S * A;
    [~, R, J] = qr(A_hat, 0);
    %disp("R")
    %disp(R)
%{
    J = [4
2
3
1];

    R = [1.94293792674971266266,   0.10181771205528805657,  -0.02474853921682208802,   0.62707526049019945980,
	   0,  -0.21356606722851376179,  -0.01139866225364932761,   0.01117582129114204348,
	   0,   0,   0.13602375541540923098,   0.04979970566671458598,
	   0,   0,   0,   0.11462434270897559063];
%}

    R_hat = R(1:k, 1:k);
    A_cpy = A_cpy(:, J);

    %disp("inv(R_hat)")
    %disp(inv(R_hat))


    %disp("A_cpy")
    %disp(A)
    %disp(J)
    %disp("A_cpy * P")
    %disp(A_cpy)

    A_sp_pre = A_cpy(:, 1:k) * inv(R_hat);
    %A_sp_pre = A_cpy(:, 1:k) / (R_hat);
    %disp("A_sp_pre")
    %disp(A_sp_pre)

    [Q, R_sp] = CholQR(A_sp_pre);

    %disp("RS")
    %disp(size(R_sp))
    %disp(size(R))
    R = R_sp * eye(k, n) * R;


end

function[Q, R] = CholQR(A)
    
    G = A' * A;
    

    R = chol(G);

    %disp("R_chol")
    %disp(R)


    Q = A / R;

end