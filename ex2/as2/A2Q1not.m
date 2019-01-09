clc;
clear;
close all;

X = [ 0 1];
Y = [ 1 0];
W = -1;
b = -1;
iter=50;
alpha=0.05;

g = zeros(1,size(X, 2));
h = zeros(1,size(X, 2));
e = zeros(iter,1);

for t=1:iter
    for i=1:size(X, 2)
        g(i)= b + X(i)*W;
        h(i)= (g(i)>=0.5);
        if (h(i)~=Y(i))
            W = W + (alpha*Y(i)*X(i));
            b = b + (alpha*Y(i));
        end
    end
    e(t) = sum( (Y-h).^2);
end
plot(e)
 W
 b