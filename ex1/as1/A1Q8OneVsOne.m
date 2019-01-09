clc;
clear;
close all;

data = xlsread('data4.xlsx');
X = [ones(size(data,1),1) data(:,1:4)];
Y = data(:,5);
n = size(X,2);
m = size(X,1);

%-------------------------------------
%Normalization
for j=2:size(X,2)
   mn=0;
   sd=0;
   
   for i=1:size(X,1)
       mn=mn+X(i,j);
   end
   mn=mn/size(data,1);
   
   for i=1:size(X,1)
       sd=sd+(X(i,j)-mn)^2;
   end
   sd=sqrt(sd/size(X,1));
   
   for i=1:size(X,1)
       X(i,j)=(X(i,j)-mn)/sd;
   end 
end   
%------------------------------------

%------------------------------------
%hold out cross validation
x=[]; y=[];
xt=[]; yt=[];

for i=1:size(data,1)
    if rand<0.6
        x=[x; X(i,:)];
        y=[y; Y(i,:)];
    else
        xt=[xt; X(i,:)];
        yt=[yt; Y(i,:)];
    end
end 
%------------------------------------

m=size(x,1);
n=size(x,2);
k=3;

zp = zeros(size(yt,1), 3);
yp = zeros(size(yt,1), 1);

for c1=1:k-1
    for c2=c1+1:k
        
        xT=[]; z=[];
        for i=1:m
            if y(i)==c1
                xT=[xT; x(i,:)];
                z=[z; 0];
            elseif y(i)==c2
                xT=[xT; x(i,:)];
                z=[z; 1];                
            end
        end   
        
        iter=100;
        alpha=0.05;
        W = rand(1,n);
        h = zeros(size(xT,1),1);
        J = zeros(iter,1);

        h=exp(-(xT*W'));
        for i=1:size(xT,1)
            h(i) = 1/(1+h(i)); 
        end

        for t=1:iter 
            dec = (z.*(ones(size(xT,1),1)-h) - (ones(size(xT,1),1)-z).*(h))' * xT;
            W= W - alpha*1/size(xT,1)*(sum(dec) ) ;   
   
            h=exp(-(xT*W'));
            for i=1:size(xT,1)
                h(i) = 1/(1+h(i)); 
            end  
        end
        
        zp(:,c1+c2-2) = exp(-(xt*W'));
        for i=1:size(xt,1)
            zp(i,c1+c2-2) = 1/(1+zp(i,c1+c2-2));
            if(zp(i,c1+c2-2)<0.5)
                zp(i,c1+c2-2)=c1;
            else
                zp(i,c1+c2-2)=c2;
            end
        end         
        
    end
end   
yp=mode(zp,2); 

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