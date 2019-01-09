clc;
clear; 
close all;

data = xlsread('data3.xlsx');
m=size(data,1);
n=size(data,2);
X = data(:,(1:n-1));
Y = data(:,n);

x1=[];
x2=[];
xt=[];
yt=[];

for i=1:m
   if rand<0.6
      if (Y(i)==1)
          x1=[x1; X(i,:)];     
      elseif (Y(i)==2)
          x2=[x2; X(i,:)];
      end    
   else
       xt=[xt; X(i,:)];
       yt=[yt; Y(i)];
   end   
end  

m1=size(x1,1);
m2=size(x2,1);

mu1 = sum(x1)/m1;
mu2 = sum(x2)/m2;

sig1 = x1'*x1;
sig2 = x2'*x2;

sqd1 = sqrt(det(sig1));
sqd2 = sqrt(det(sig2));
inv1 = inv(sig1);
inv2 = inv(sig2);

yp=zeros(size(xt,1), 1);
RHS = m2/m1; %p(y1)/p(y2)

for i=1:size(xt,1)
    e1 = exp(-1/2*(xt(i,:)-mu1)*inv1*(xt(i,:)-mu1)');
    e2 = exp(-1/2*(xt(i,:)-mu2)*inv2*(xt(i,:)-mu2)');    
    LHS = sqd2/sqd1 * e1/e2;
    if LHS > RHS
        yp(i)= 1;
    else 
        yp(i) = 2;
    end    
end 

ConfMat = zeros(2,2);
for i=1:size(xt,1)
   if(yt(i)==1 && yp(i)==1)
       ConfMat(1,1) = ConfMat(1,1) + 1;
   elseif(yt(i)==1 && yp(i)==2)
       ConfMat(1,2) = ConfMat(1,2) + 1;
   elseif(yt(i)==2 && yp(i)==1)
       ConfMat(2,1) = ConfMat(2,1) + 1;
   elseif(yt(i)==2 && yp(i)==2)
       ConfMat(2,2) = ConfMat(2,2) + 1;  
   end    
end   
ConfMat

fprintf("Accuracy = %f\n", (ConfMat(1,1)+ConfMat(2,2))/(ConfMat(1,1)+ConfMat(1,2)+ConfMat(2,1)+ConfMat(2,2)));
fprintf("Specificity = %f\n", ConfMat(1,1)/(ConfMat(1,1)+ConfMat(1,2)) );
fprintf("Sensitivity = %f\n", ConfMat(2,2)/(ConfMat(2,1)+ConfMat(2,2)) );
