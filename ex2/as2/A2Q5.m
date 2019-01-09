clc;
clear;
close all;

sigmoid = @(x) 1./(1 + exp(-x));

H = 20;
lr = 0.25;
p = 0.025;
K = 3;

dat = csvread('dataset.csv');
X = normalize(X,1);
Y = ind2vec(dat(:, 8)')';

data = [X full(Y)];
data = data(randperm(150), :);
X = data(:, 1:7);
Y = data(:, 8:10);

x_train = X(1:105, :);
x_test = X(106:150, :);
y_train = Y(1:105, :);
y_test = Y(106:150, :);
[M, N] = size(x_train);
[P, Q] = size(x_test);

w1 = (rand([N+1 H]) - rand([N+1 H]))/100;
w2 = (rand([H+1 3]) - rand([H+1 3]))/100;
b = -1;

x = [b*ones(M, 1) x_train];
Dw1 = zeros(N+1, H);
Dw2 = zeros(H+1, 3);
cost = zeros([1000 1]);

for k = 1:1000
  z = [b*ones(M, 1) sigmoid(x_train*w1)];
  y = sigmoid(z*w2);
  cost(k) = mean(mean((y_train - y).^2));
  df = y.*(1-y);
  d2 = df.*(y_train - y);
  Dw2 = (lr/N)*d2'*z;
  w2 = (1+p)*w2 + Dw2';
  
  df = z.*(1-z);
  d1 = df.*(d2*w2');
  d1 = d1(:, 2:end);
  Dw1 = (lr/N)*d1'*x_train;
  w1 = (1+p)*w1 + Dw1';
end

N = 30;
[l, mu] = kmeans(y, N);

for i = 1:size(y, 1)
    for j = 1:size(mu, 1)
        H(i, j) = (norm(y(i, :) - mu(j, :)))^3;
    end
end

w = pinv(H)*y_train;

x_test = [b*ones(P, 1) x_test];
z_p1 = [b*ones(P, 1) sigmoid(x_test*w1)];
z_p2 = sigmoid(z_p1*w2);
for i = 1:size(z_p2, 1)
    for j = 1:size(mu, 1)
        H_t(i, j) = (norm(z_p2(i, :) - mu(j, :)))^3;
    end
end
y_p = H_t*w;
for i = 1:size(y_p, 1)
    [val, idx] = max(y_p(i, :));
    y_p(i, idx) = 1;
    for j = 1:3
        if y_p(i, j) ~= 1
            y_p(i, j) = 0;
        end
    end
end
correct = 0;
for i = 1:size(y_test, 1)
    if y_p(i, :) == y_test(i, :)
        correct = correct + 1;
    end
end
val_acc = correct/45;
plot(cost);
fprintf("Test accuracy: %d\n", val_acc);