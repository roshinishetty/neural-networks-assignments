clc;
clear;
close all;

X = [ 0 0 1 1; 0 1 0 1];
Y = [ 0 1 1 1];
W = [ 0 0 ];
b = 0;
iter=50;
alpha=0.05;

g = zeros(1,size(X, 2));
h = zeros(1,size(X, 2));
e = zeros(iter,1);

for t=1:iter
    for i=1:size(X, 2)
        g(i)= b + X(1,i)*W(1) + X(2,i)*W(2);
        h(i)= (g(i)>=0.5);
        if (h(i)~=Y(i))
            for j=1:size(X,1)
                W(j) = W(j) + (alpha*Y(i)*X(j,i));
            end
            b = b + (alpha*Y(i));
        end
    end
    e(t) = sum( (Y-h).^2);
end
plot(e)
W
b