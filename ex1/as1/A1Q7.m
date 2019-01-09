clc;
clear;
close all;
 
data = xlsread('data3.xlsx');
m=size(data,1);
n=size(data,2);
X = [ones(m,1), data(:,1:n-1)];
Y = data(:,n);
Z = zeros(m,1);

%---------------------------------%
%Normalizing features
for j=2:n
   mn=0;
   sd=0;
   for i=1:m
       mn = mn + X(i,j);
   end
   mn = mn/size(X,1);
   
   for i=1:m
       sd = sd + (X(i,j) - mn)^2;
   end
   sd = sqrt(sd/size(X,1));
   
   for i=1:m
       X(i,j) = (X(i,j) - mn) / sd;
   end    
end
%------------------------------------

for i=1:m
    if Y(i)==1
        Z(i)=0;
    elseif Y(i)==2
        Z(i)=1;
    end
end

x=[];
xt=[];
y=[];
yt=[];

for i=1:m
   if rand<0.6
       x=[x; X(i,:)];
       y=[y; Z(i)];
   else
       xt=[xt; X(i,:)];
       yt=[yt; Z(i)];
   end   
end    

iter=100;
alpha=0.05;
W = rand(1,n);
h = zeros(size(x,1),1);
J = zeros(iter,1);

h=exp(-(x*W'));
for i=1:size(x,1)
   h(i) = 1/(1+h(i)); 
end

for t=1:iter 
    dec = (y.*(ones(size(x,1),1)-h) - (ones(size(x,1),1)-y).*(h))' * x;
    W= W - alpha*1/size(x,1)*(sum(dec) ) ;   
   
    h=exp(-(x*W'));
    for i=1:size(x,1)
        h(i) = 1/(1+h(i)); 
    end  
end

ConfMat = zeros(2,2);

ht=xt*W';
for i=1:size(xt,1) 
    ht(i) = (ht(i)>=0.5);
end 

for i=1:size(ht)
   if ht(i)==yt(i)==0 
        ConfMat(1,1) = ConfMat(1,1) +1;
   elseif yt(i)==1 && ht(i)==0 
        ConfMat(2,1) = ConfMat(2,1) +1;
   elseif yt(i)==0 && ht(i)==1
        ConfMat(1,2) = ConfMat(1,2) +1;
   elseif yt(i)==1 && ht(i)==1
        ConfMat(2,2) = ConfMat(2,2) +1;
   end     
end   
ConfMat

fprintf("Accuracy = %f\n", (ConfMat(1,1)+ConfMat(2,2))/(ConfMat(1,1)+ConfMat(1,2)+ConfMat(2,1)+ConfMat(2,2)));
fprintf("Specificity=%f\n", ConfMat(1,1)/(ConfMat(1,1)+ConfMat(1,2)) );
fprintf("Sensitivity=%f\n", ConfMat(2,2)/(ConfMat(2,1)+ConfMat(2,2)) );