

function[A_cpy, Q, R, P] = rqrcp_chol()

    A = randn(1000, 250);
    A = [A, A, A, A];
    k = 500;
    b_sz = 50;

    A_cpy = A;
    cnt = 0;


    for i = 1 : 1
        A = A_cpy;
        [m, n] = size(A);
    
        Q = eye(m, m);
        R = zeros(m, n);
        P = eye(n, n);
    
   
        for j = 1:(k / b_sz)
    
            %disp("A")
            %disp(A)
    
            sz = size(A, 1);
    
            A_hat = randn(k, sz)  * A;
    
            %disp("J")
            [~, R_hat, J] = qr(A_hat);

            % Adjusting R_hat
            R_hat = R_hat(1: b_sz, 1: b_sz);

            if j ~= 1
                %disp("Original R")
                %disp(R)
                %disp("Permuted R");
                R = piv_swap(R, J);
            end
    
            % Preconditioning and QR
            A_sp_pre = A * J(:, 1:b_sz) / R_hat;
            [Q_, ~] = CholQR(A_sp_pre);

            [Q_, ~] = qr(Q_);
            R11_full = Q_' * A_sp_pre;

            R11 = R11_full(1:b_sz, :) * R_hat;

            R12 = Q_(:, 1:b_sz)' * A * J(:, b_sz + 1:end);
    
            A = Q_(:, b_sz + 1:end)' * A * J(:, b_sz + 1:end);
    
            QI = eye(m, m);
            PI = eye(n, n);
    
            QI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = Q_;
            PI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = J;

            %disp(PI)
    
            Q = Q * QI;
            P = P * PI;
            
            R1 = [R11 R12];
    
            R((j - 1) * b_sz + 1: j * b_sz, (j - 1) * b_sz + 1: end) = R1;
            
            %disp("Q")
            %disp(Q)
            %disp("R")
            %disp(R)
            %disp("P")
            %disp(P)

        end
    
        %disp("pivots needed:");
        %disp(A_cpy \ (Q * R));
        
        %disp("pivots have");
        %disp(P);
    
        %disp("A - QR");
        %disp(A_cpy * P - Q * R);
        
        nrm = norm(A_cpy * P - Q * R);
        if nrm > 10^-14
            %disp("FAILED");
            cnt = cnt + 1;
        end
    end
    
    %disp(cnt / 5000);
    disp(nrm)

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
