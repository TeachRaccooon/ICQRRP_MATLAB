

% THIS ONE WORKS - actual repeated sampling
% On output, approximation is A - Q * R
function[Q, R, J] = rqrcp_repeated_sampling(A, k, b_sz)

    A_cpy = A;
    cnt = 0;


    for i = 1 : 1
        A = A_cpy;
        [m, n] = size(A);
    
        Q = eye(m, m);
        R = zeros(m, n);
        P = eye(n, n);
    
        

        for j = 1:(k / b_sz)
    
            rng(j)
            %disp("A")
            %disp(A)
    
            sz = size(A, 1);
    
            S = randn(k, sz);
            A_hat = S  * A;
    
            %disp("J")
            [~, ~, J] = qr(A_hat);

            if j ~= 1
                %disp("Original R")
                %disp(R)
                %disp("Permuted R");
                R = piv_swap(R, J);
            end
    
            disp(A)
            [Q_, ~] = CholQR(A * J(:, 1:b_sz));

            %disp("Approximating QR before constructing full")
            %disp(A * J(:, 1:b_sz) - Q_ * R11_full)

            if size(Q_, 1) == 4
                
                I = eye(4, 4);
                Q_ = [Q_ I(:, 3:4)];
            end
            
            % Fixing the Q issue
            [Q_, ~] = qr(Q_); %%%%%%%%%%% NEED THIS
            %disp("Ful Q")
            %disp(Q_)
            %disp("Full R")
            %disp(R11_full)

            % Temporary check
            %R_buf = [R11_full; zeros(size(A, 1) - b_sz, b_sz)];
            %disp("Approximating QR after constructing full Q")
            %disp(A * J(:, 1:b_sz) - Q_ * R_buf)

            % Need to reconstruct R too
            R11_full = Q_' * A * J(:, 1:b_sz);  %%%%%%%%%%% NEED THIS

            %disp("Approximating QR after reconstructing R")
            %disp(A * J(:, 1:b_sz) - Q_ * (Q_' * A * J(:, 1:b_sz)))

            R11 = R11_full(1:b_sz, :); %%%%%%%%%%% NEED THIS
    
            R12 = Q_(:, 1:b_sz)' * A * J(:, b_sz + 1:end);
    
            A = Q_(:, b_sz + 1:end)' * A * J(:, b_sz + 1:end);
            %A = eye(m - (j - 1) * b_sz, m - j * b_sz)' * A * J(:, b_sz + 1:end);
    
            QI = eye(m, m);
            PI = eye(n, n);
    
            QI((j - 1) * b_sz + 1: end, (j - 1) * b_sz + 1 : end) = Q_;
            %QI((j - 1) * b_sz + 1: end, end - b_sz + 1 : end) = Q_(:, 1:b_sz);
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


%{
% Version with B updating
function[Q, R, J] = rqrcp_repeated_sampling(A, k, b_sz)

    A_cpy = A;
    cnt = 0;


    for i = 1 : 5000
        A = A_cpy;
        [m, n] = size(A);
    
        Q = eye(m, m);
        R = zeros(m, n);
        P = eye(n, n);
    
        A_hat = randn(k, m)  * A;
   
        for j = 1:(k / b_sz)
    
            [~, R_hat, J] = qr(A_hat);

            if j ~= 1
                %disp("Original R")
                %disp(R)
                %disp("Permuted R");
                R = piv_swap(R, J);
            end
    
            [Q_, R11_full] = qr(A * J(:, 1:b_sz));
    
            R11 = R11_full(1:b_sz, :);
    
            R12 = Q_(:, 1:b_sz)' * A * J(:, b_sz + 1:end);
    
            A = Q_(:, b_sz + 1:end)' * A * J(:, b_sz + 1:end);

            B1 = R_hat(1:b_sz, b_sz + 1:end) - (R_hat(1:b_sz, 1:b_sz) / R11) * R12;
            B2 = R_hat(b_sz + 1:end, b_sz + 1:end);
    
            A_hat = [B1; B2];
    
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
    
    disp(cnt / 5000);

end
%}

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