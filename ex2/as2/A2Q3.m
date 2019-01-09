clc;
clear;
close all;

data = xlsread('dataset.xlsx');

p = 7; % no of input neurons
m = 3; % no of output neurons
mu = 0.75; %learning rate
alpha = 0.001; %momentum rate
epoch = 100; % no of iterations
MSETarget = 1e-20; % targetted mse
MSE = [];
mseT = [];

X = data(:, (1:7));
D = classifyData(data(:,8));
[X,D,Xt,Dt] = CrossValidation(X,D); 

[N, p] = size(X); %N no of instances, p no of inputs
bias = -1;
X = [bias*ones(N,1), X]; 
X = X';
D = D';

Nt = size(Xt,1);
Xt = [bias*ones(Nt,1), Xt];
Xt = Xt';
Dt = Dt';

for H1=3:2:7
    for H2=3:2:7

        Wx = rand(H1,p+1);
        WxAnt = zeros(H1, p+1);
        Tx = zeros(H1, p+1);
        
        Wh = rand(H2, H1+1);
        WhAnt = zeros(H2, H1+1);
        Th = zeros(H2, H1+1);

        Wy = rand(m,H2+1);
        WyAnt = zeros(m, H2+1);
        Ty = zeros(m, H2+1);

        DWy = zeros(m, H2+1);
        DWh = zeros(H2, H1+1);
        DWx = zeros(H1, p+1);
        MSETemp = zeros(1, epoch);

        for i = 1:epoch
            k = randperm(N);
            X = X(:,k);
            D = D(:,k);
            
            V = Wx*X;
            Z = 1./(1+exp(-V));
            S = [bias*ones(1,N); Z];
            
            M = Wh*S;
            T = 1./(1+exp(-M));
            U = [bias*ones(1,N); T];
            
            G = Wy*U;
            Y = 1./(1+exp(-G));
            E = D -Y;
            mse = mean(mean(E.^2));
            MSETemp(i) = mse;
            if (mse < MSETarget)
                MSE = MSETarget(1:i);
                return;
            end
   
   %%%%%%%%%Back Propagation%%%%%%%%%%
            df = Y.*(1-Y);
            dGy = df.* E;
            DWy = mu/N * dGy * U';
            Wy = (1+alpha) * Wy + DWy;
   
            df = U.*(1-U);
            dGh = df.*(Wy' * dGy);
            dGh = dGh(2:size(dGh,1),:);
            DWh = mu/N * dGh * S';
            Wh = (1+alpha) * Wh + DWh;
            
            df = S.*(1-S);
            dGx = df.* (Wh' * dGh);
            dGx = dGx( 2:size(dGx,1), :);
            DWx = mu/N * dGx * X';
            Wx = (1+alpha)*Wx + DWx;
        end   
        
        MSE =[MSE; MSETemp];
        
        %%%%working on test cases%%%%
        A = Wx*Xt;
        B = 1./(1+exp(-A));
        C = [bias*ones(1,Nt); B];
        
        I = Wh*C;
        E = 1./(1+exp(-I));
        F = [bias*ones(1,Nt); E];
        
        G = Wy*F;
        Yt = 1./(1+exp(-G));
        
        Et = Dt - Yt;
        mseT =[mseT; mean(mean(Et.^2))];
    end
end

smallest = 1;
for i=1:size(mseT)
    if(mseT(i)< mseT(smallest))
        smallest = i;
    end
end

figure
plot(MSE(smallest,:));