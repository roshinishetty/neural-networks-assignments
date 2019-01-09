clc;
clear;
close all;

X = [ 0 0 1 1; 0 1 0 1];
H = [0 0 0 1; 1 0 0 0];
W = [ -1 -1 ];
b = -1;
iter=50;
alpha=0.05;

g = zeros(1,size(X, 2));
h = zeros(1,size(X, 2));
e = zeros(iter,1);

for t=1:iter
    for i=1:size(X, 2)
        g(i)= b + X(1,i)*W(1) + X(2,i)*W(2);
        h(i)= (g(i)>=0.5);
        if (h(i)~=H(1,i))
            for j=1:size(X,1)
                W(j) = W(j) + (alpha*H(1,i)*X(j,i));
            end
            b = b + (alpha*H(1,i));
        end
    end
    e(t) = sum( (H(1,:)-h).^2);
end
fprintf("Bais and weights from input to hidden layer are\n");
fprintf("%d %d %d\n",b, W(1), W(2));

W = [ -1 -1 ];
b = -1;
iter=50;
alpha=0.05;

g = zeros(1,size(X, 2));
h = zeros(1,size(X, 2));
e = zeros(iter,1);

for t=1:iter
    for i=1:size(X, 2)
        g(i)= b + X(1,i)*W(1) + X(2,i)*W(2);
        h(i)= (g(i)>=0.5);
        if (h(i)~=H(2,i))
            for j=1:size(X,1)
                W(j) = W(j) + (alpha*H(2,i)*X(j,i));
            end
            b = b + (alpha*H(2,i));
        end
    end
    e(t) = sum( (H(2,:)-h).^2);
end
fprintf("%d %d %d\n",b, W(1), W(2));

Y = [ 1 0 0 1];
W = [ 0 0 ];
b = 0;
iter=50;
alpha=0.05;

g = zeros(1,size(X, 2));
h = zeros(1,size(X, 2));
e = zeros(iter,1);

for t=1:iter
    for i=1:size(X, 2)
        g(i)= b + H(1,i)*W(1) + H(2,i)*W(2);
        h(i)= (g(i)>=0.5);
        if (h(i)~=Y(i))
            for j=1:size(H,1)
                W(j) = W(j) + (alpha*Y(i)*H(j,i));
            end
            b = b + (alpha*Y(i));
        end
    end
    e(t) = sum( (Y-h).^2);
end
plot(e)
fprintf("Bais and weights from hidden to output layer are\n");
fprintf("%d %d %d\n",b, W(1), W(2));