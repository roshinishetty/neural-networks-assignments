clc;
clear;
close all;

data = xlsread('data.xlsx');
X = data(:, 1:2);
X = [ones(size(X,1),1), X];
Y = data(:, 3);

W = rand(3,1);
iter = 1000;
alpha = 0.05;

%--------------------------------%
%Nomalizing features%
mean = zeros(1,size(X,2));
sd = zeros(1,size(X,2));
 
for j=2:size(X,2)
    for i=1:size(X,1)
        mean(j) = mean(j) + X(i,j);
    end
    mean(j) = mean(j)/size(X,1);
    
    for i=1:size(X,1)
        sd(j) = sd(j) + (X(i,j)-mean(j))^2;
    end    
    sd(j) = sqrt(sd(j)/size(X,1));
    
    for i=1:size(X,1)
        X(i,j) = (X(i,j) - mean(j)) / sd(j);
    end    
end  
%--------------------------------%

J = zeros(iter,1);
e = zeros(iter,1);
h = X * W;
hist_W = zeros(iter, size(X,2));

for k=1:iter
   for i=1:size(X,1)
      for j=1:size(X,2)
          h = X * W;
          hist_W(k,j) = W(j) - alpha * 1/(size(X,1)) * (h(i)-Y(i)) * X(i,j);
          W(j) = hist_W(k,j);
      end      
   end      
   
   h = X * W;
   J(k) = 1/(2*size(X,1)) * sum((Y-h).^2);
   
end
plot(J)
W

figure;
[w1,w2] = meshgrid(1:1:20, 1:1:20);
for i=1:size(X,1)
   h(i) = 1 + w1*X(i,2) + w2*X(i,3); 
end    
J = 1/(2*size(X,1)) * sum((Y-h).^2);