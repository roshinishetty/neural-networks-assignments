clc;
clear;
close all;

X = xlsread('data2.xlsx');

K = 2;
c = zeros(K,size(X,2));
p = randperm(size(X,1));
for i=1:K
    c(i,:) = X(p(i),:);
end    

iter=100;

for t=1:iter
    indices = zeros(size(X,1),1);
    m = size(X,1);

    for i=1:size(X,1)
        k = 1;
        min_dist = sum( ( X(i,:) - c(1,:)).^2);
        for j=1:K
            dist = sum( (X(i,:) - c(j,:)).^2);
            if(dist < min_dist)
                min_dist = dist;
                k = j;
            end
        end
        indices(i) = k;
    end    

    centroids = zeros(K, size(X,2));
    for i=1:K
        xi = X(indices==i, :);
        ck = size(xi, 1);
        centroids(i,:) = 1/ck * sum(xi);
    end    
end

figure;

clr=lines(K);
scatter3(X(:,1), X(:,2), X(:,3), 36, clr(indices,:), 'Marker', '.');
hold on;
scatter3(centroids(:,1), centroids(:,2), centroids(:,3), 100, clr, 'Marker', 'o', 'Linewidth', 3);
pause;

figure;
clr=lines(K);
scatter3(X(:,2), X(:,3), X(:,4), 36, clr(indices,:), 'Marker', '.');
hold on;
scatter3(centroids(:,1), centroids(:,2), centroids(:,3), 100, clr, 'Marker', 'o', 'Linewidth', 3);
pause;

figure;
clr=lines(K);
scatter3(X(:,1), X(:,3), X(:,4), 36, clr(indices,:), 'Marker', '.');
hold on;
scatter3(centroids(:,1), centroids(:,2), centroids(:,3), 100, clr, 'Marker', 'o', 'Linewidth', 3);
pause;

figure;
clr=lines(K);
scatter3(X(:,1), X(:,2), X(:,4), 36, clr(indices,:), 'Marker', '.');
hold on;
scatter3(centroids(:,1), centroids(:,2), centroids(:,3), 100, clr, 'Marker', 'o', 'Linewidth', 3);
pause;

%plot(X(indices==1,1), X(indices==1,2), 'r', 'MarkerSize',12);
%hold on;
%plot(X(indices==2,1), X(indices==2,2), 'b', 'MarkerSize',12);
%hold on;
%plot(centroids(1,1:2), centroids(2,1:2), 'kx', 'MarkerSize', 15);

%plot3(X(:,1), X(:,2), X(:,3));
%tri = delaunay(X(:,1), X(:,2));
%trimesh(tri, X(:,1), X(:,2), X(:,3));
%plot3(X(:,1), X(:,2), X(:,3), centroids(:,1:3) );


%[x1, x2, x3] = meshgrid( X(:,1), X(:,2), X(:,3) );
%mesh(x1,x2,centroids(:,1:2));
%scatter(centroids(:,1:3));
%scatter(X(:,1), X(:,2), centroids(:,1));