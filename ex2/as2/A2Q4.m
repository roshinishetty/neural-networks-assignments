clc;
clear;
close all;

data = xlsread('dataset.xlsx');
X = data(:,(1:7));
Y = data(:,8);

X = normalize(X,1);
Z = classifyData(Y);

[x,y,xt,yt] = CrossValidation(X,Y);  
clusters = [1 5 10];
for c=1:3    
[l,mu]=kmeans(x,clusters(c));

H = zeros(size(x,1), size(mu,1));
for i=1:size(x,1)
    for j=1:size(mu,1)
        H(i,j) = (norm(x(i,:)-mu(j,:)))^3;
    end
end

kk=pinv(H);
w=kk*y;

Ht = zeros(size(xt,1), size(mu,1));
for i=1:size(xt,1)
    for j=1:size(mu,1)
        Ht(i,j) = (norm(xt(i,:)-mu(j,:)))^3;
    end
end
yp=Ht*w;

for i=1:size(yp,1)
   if(yp(i)<1.5)
       yp(i)=1;
   elseif(yp(i)<2.5)
       yp(i)=2;
   else
       yp(i)=3;
   end    
end    
ConfMat = zeros(3,3);
for il=1:size(yp,1)
    if yt(il)==1 &&yp(il)==1
        ConfMat(1,1) = ConfMat(1,1)+1;
    elseif yt(il)==1 && yp(il)==2
        ConfMat(1,2) = ConfMat(1,2)+1;
    elseif yt(il)==1 &&yp(il)==3
        ConfMat(1,3) = ConfMat(1,3)+1;
    elseif yt(il)==2 &&yp(il)==1
        ConfMat(2,1) = ConfMat(2,1)+1;
    elseif yt(il)==2 &&yp(il)==2
        ConfMat(2,2) = ConfMat(2,2)+1;  
    elseif yt(il)==2 && yp(il)==3
        ConfMat(2,3) = ConfMat(2,3)+1;   
    elseif yt(il)==3 && yp(il)==1
        ConfMat(3,1) = ConfMat(3,1)+1;
    elseif yt(il)==3 && yp(il)==2
        ConfMat(3,2) = ConfMat(3,2)+1;  
    elseif yt(il)==3 && yp(il)==3
        ConfMat(3,3) = ConfMat(3,3)+1;         
    end    
end
ConfMat
acc(c) = (ConfMat(1,1)+ConfMat(2,2)+ConfMat(3,3))/size(yp,1);
fprintf("%d\n", acc(c));
end
fprintf("Max Accuracy:%d\n", max(acc));