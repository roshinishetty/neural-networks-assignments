clc;
clear;
close all;

data = xlsread('data4.xlsx');
m = size(data, 1);
n = size(data, 2);
X = data(:, (1:n-1));
Y = data(:, n);

x1 = [];
x2 = [];
x3 = [];
xt = [];
yt = [];

for i=1:m
   if rand<0.7
      if Y(i)==1
          x1 = [x1; X(i,:)];
      elseif Y(i)==2
          x2 = [x2; X(i,:)];
      elseif Y(i)==3
          x3 = [x3; X(i,:)];
      end
   else
       xt = [xt; X(i,:)];
       yt = [yt; Y(i)];
   end        
end    

m1 = size(x1, 1);
m2 = size(x2, 1);
m3 = size(x3, 1);

mu1 = sum(x1)/m1;
mu2 = sum(x2)/m2;
mu3 = sum(x3)/m3;

sig1 = x1'*x1;
sig2 = x2'*x2;
sig3 = x3'*x3;

sqd1 = sqrt(det(sig1));
sqd2 = sqrt(det(sig2));
sqd3 = sqrt(det(sig3));

inv1 = inv(sig1);
inv2 = inv(sig2);
inv3 = inv(sig3);

yp = zeros(size(xt,1), 1);

for i=1:size(xt,1)
   e1 = exp(-1/2*(xt(i,:)-mu1)*inv1*(xt(i,:)-mu1)'); 
   e2 = exp(-1/2*(xt(i,:)-mu2)*inv2*(xt(i,:)-mu2)'); 
   e3 = exp(-1/2*(xt(i,:)-mu3)*inv3*(xt(i,:)-mu3)');
   
   a1 = 1/sqd1*e1*m1;
   a2 = 1/sqd2*e2*m2;
   a3 = 1/sqd3*e3*m3;
   
   if(a1>=a2)
       if(a1>a3)
           yp(i) = 1;
       else
           yp(i) = 3;
       end
   else
       if(a2>a3)
           yp(i) = 2;
       else
           yp(i) = 3;
       end
   end    
end   

ConfMat = zeros(3,3);
for i=1:size(xt,1)
   if(yt(i)==1 && yp(i)==1)
       ConfMat(1,1) = ConfMat(1,1) + 1;
   elseif(yt(i)==1 && yp(i)==2)
       ConfMat(1,2) = ConfMat(1,2) + 1;
   elseif(yt(i)==1 && yp(i)==3)
       ConfMat(1,3) = ConfMat(1,3) + 1;       
   elseif(yt(i)==2 && yp(i)==1)
       ConfMat(2,1) = ConfMat(2,1) + 1;
   elseif(yt(i)==2 && yp(i)==2)
       ConfMat(2,2) = ConfMat(2,2) + 1;
   elseif(yt(i)==2 && yp(i)==3)
       ConfMat(2,3) = ConfMat(2,3) + 1;
   elseif(yt(i)==3 && yp(i)==1)
       ConfMat(3,1) = ConfMat(3,1) + 1;
   elseif(yt(i)==3 && yp(i)==2)
       ConfMat(3,2) = ConfMat(3,2) + 1;
   elseif(yt(i)==3 && yp(i)==3)
       ConfMat(3,3) = ConfMat(3,3) + 1;       
   end    
end   
ConfMat

fprintf("Overall Accuracy = %f\n", (ConfMat(1,1)+ConfMat(2,2)+ConfMat(3,3))/(ConfMat(1,1)+ConfMat(1,2)+ConfMat(2,1)+ConfMat(2,2)));
fprintf("Individual Accuracy:\n");
fprintf("Class 1: %f\n",ConfMat(1,1)/(ConfMat(1,1)+ConfMat(1,2)+ConfMat(1,3)) );
fprintf("Class 2: %f\n",ConfMat(2,2)/(ConfMat(2,1)+ConfMat(2,2)+ConfMat(2,3)) );
fprintf("Class 3: %f\n",ConfMat(3,3)/(ConfMat(3,1)+ConfMat(3,2)+ConfMat(3,3)) );