function [x, y, xt, yt] = CrossValidation(X,Y)
x=[];
y=[];
xt=[];
yt=[];

for i=randperm(size(X,1))
    if rand<0.7
        x=[x; X(i,:)];
        y=[y; Y(i,:)];
    else
        xt=[xt; X(i,:)];
        yt=[yt; Y(i,:)];
    end
end
end