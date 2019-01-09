clc;
clear;
close all;

data = xlsread('data.xlsx');
X = data(:, 1:2);
X = [ones(size(X,1),1), X];
Y = data(:, 3);

%W = [0.5; 0.5; 0.5];
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

hist_W = zeros(size(W));
h = X * W; 
J = zeros(iter,1);
e = zeros(iter,1);

for k=1:iter
  for j =1:size(W)
      hist_W(k,j) = W(j) - alpha * 1/(size(X,1)) * (h-Y)' * X(:,j);
  end
  
  for j=1:size(W)
      W(j) = hist_W(k,j);
  end
  
  h = X * W; 
  J(k) = 1/(2*size(X,1)) * sum((Y - h).^2);
end
plot(J)
W

hist_J = zeros(length(hist_W(:,1)), length(hist_W(:,2)) );
for i=1:length(hist_W(:,1))
    for j=1:length(hist_W(:,2))
        t=[hist_W(i,1); hist_W(j,1)];
        e=0;
        for k=1:size(X,1)
            e = e+(Y(k) - (X(k,1) + i*X(k,2) + j*X(k,3)) )^2; 
        end    
        hist_J(i,j)=1/(2*size(X,1)) * e;
    end
end    
figure;
surf(hist_W(:,1), hist_W(:,2), hist_J); 