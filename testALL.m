clear all
clc




N = 10;
n = 0:N-1;
delay = [1 ];
amp_k = [1 ];
doppler_spread = [1/N];
F_l = doppler_spread(1);
L = 1;
c1 =  1/(2*N);
c2 =  1/(2*N);
Gamma_c1_N = diag(exp(-1i*2*pi*(c1.*(0:N-1).^2)));
Gamma_c2_N = diag(exp(-1i*2*pi*(c2.*(0:N-1).^2)));
F_N = (1/sqrt(N))*dftmtx(N);



EyeMat = eye(N);
Per = [EyeMat(:, 2:end) EyeMat(:,1)];
H = zeros(N);
for l = 0:length(delay)-1%Number of Cluster
    A_i_n                           = amp_k(l+1);% It can be RV
    f_i_n                           = doppler_spread(l+1);
    
    
    Delta_ki = diag(exp(-1i*2*pi.*n*f_i_n));
    onesCP = ones(1, N);
    onesCP(1:delay(l+1)) = fliplr(exp(-1i*2*pi*c1*(N^2 - 2*N*(1:delay(l+1)))));
    Gamma_CP = diag(onesCP);
    H = H + A_i_n*Delta_ki*Gamma_CP*Per^(delay(l+1));
    H_each(:, :, l+1) = A_i_n*Delta_ki*Gamma_CP*Per^(delay(l+1));
end
A = Gamma_c1_N*H*Gamma_c1_N';

for i = 0:N-1
    for j = 0:N-1
        test = 0;
        test2 = 0;
        test3 = 0;
        for n = 0:N-1
            test = test + exp(-1i*2*(pi/N)*(i*n - mod(n-delay(L), N)*j))*A(n+1, mod(n-delay(L), N)+1);
            test2 = test2 + exp(-1i*2*(pi/N)*(i*n - (n-delay(L))*j))*exp(1i*2*(pi/N)*(c1*N*(delay(L)^2 - 2*n*delay(L))-F_l*n*N));
            test3 = test3 + exp(-1j*(2*pi/N)*(i - j + N*F_l + 2*N*c1*delay(L))*n)
        end
        BB_L1(i+1, j+1)=1/N*test;
        BBB_L1(i+1, j+1)=1/N*test2;
        BBB_2(i+1, j+1) = (1/N)*exp(1j*2*(pi/N)*(N*c1*delay(L)^2 - j*delay(L)))*test3;
    end
end

B = F_N*A*F_N'
BB_L1;
max(max(B - BB_L1));
max(max(BBB_L1 - BB_L1));
max(max(B - BBB_2))

C = Gamma_c2_N*B*Gamma_c2_N';
%Gamma_c2_N*F_N*Gamma_c1_N*H_each(:, :, 2)*Gamma_c1_N'*F_N'*Gamma_c2_N';

%testing

for L = 1:100
     A = zeros(20,5);
    for n = 100:10000
        %N = 2^n;
        N = n;
        c2 = sqrt(2)/(2*N);
        X = 1:N-1;
        x = 0;
        if ~isempty(find(mod(X.*(2*N*c2.*X + L/2), N) == 0))
            N;
            x = X(find(mod(X.*(2*N*c2.*X + L/2), N) == 0));
            N ;
            L;
            a = min(length(find(factor(L) == 2)), n-1);
            A(n, :) = [n, L, length(x), length(x)/N, 2^a-1];
        end
    end
    A(:, :);
    [a b] = max(A(:, 3))
    if (a ~= 0)
        ali = 1;
    end
end


