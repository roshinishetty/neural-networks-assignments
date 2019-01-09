clc;
clear;
close all;

data = xlsread('data.xlsx');
X = [ones(size(data,1),1) data(:,1:2)];
Y = data(:,3);

%--------------------------------------%
%Normalizing features
mean = zeros(1,size(X,2));
sd = zeros(1,size(X,2));

for i=2:size(X,2)
   for j=1:size(X,1)
       mean(i) = mean(i) + X(j,i);
   end
   mean(i) = mean(i)/size(X,1);
   
   for j=1:size(X,1)
       sd(i) = sd(i) + (X(j,i) - mean(i))^2;
   end
   sd(i) = sqrt(sd(i)/size(X,1));
   
   for j=1:size(X,1)
      X(j,i) = (X(j,i) - mean(i))/sd(i); 
   end    
end    
%-------------------------------------%

iter=1000;
alpha=0.05;
regCof=0.01;

fprintf("Using batch gradient descent:\n");

hist_W = zeros(iter,size(X,2));
J = zeros(iter,1);
W=rand(3,1);
h=X * W;

for t=1:iter
    for j=1:size(X,2)
        hist_W(t,j) = (1-alpha*regCof)*W(j) - alpha * 1/(size(X,1)) * (h-Y)' * X(:,j);
    end
    
    for j=1:size(X,2)
        W(j) = hist_W(t,j);
    end
    
    h=X * W;
    J(t) = 1/2 * (sum((h-Y).^2)*1/(size(X,1)) + regCof*sum(W.^2)); 
end    
plot(J)
W
pause;



fprintf("Using stochastic gradient descent");

hist_W = zeros(iter,size(X,2));
W = rand(3,1);
h = X * W;

for t=1:iter
 for i=1:size(X,1)
     for j=1:size(X,2)
         hist_W(t,j) = (1-alpha*regCof)*W(j) - alpha*1/size(X,1)*(h(i)-Y(i))*X(i,j); 
     end    
 end    
 
 for j=1:size(X,2)
     W(j) = hist_W(t,j);
 end
 
 h = X * W;
 J(t) = 1/2 *( 1/size(X,1) * sum((Y-h).^2) + regCof * sum(W.^2) );
end    

figure
plot(J)
W
