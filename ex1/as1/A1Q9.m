%not working
clc;
clear;
close all;

data=xlsread('data4.xlsx');
X=[ones(size(data,1),1) data(:,1:4)];
Y=data(:,5);

acc_mean=0;
for j=2:size(X,2)
    mn=0;
    sd=0;
    for i=1:size(X,1)
        mn = mn + X(i,j);
    end
    mn = mn/size(X,1);
    
    for i=1:size(X,1)
        sd = sd + (X(i,j) - mn)^2;
    end
    sd = sqrt(sd/size(X,1));
    
    for i=1:size(X,1)
       X(i,j) = (X(i,j) - mn)/sd; 
    end    
end

for ab=1:5
    %------------------------
    x=[]; y=[];
    xt=[]; yt=[];
    u=size(X,1)/5*ab;
    l=size(X,1)/5*(ab-1) + 1;
       
    for i=1:size(X,1)
       if (i<=u && i>l)
           x=[x; X(i,:)];
           y=[y; Y(i)];
       else
           xt=[xt; X(i,:)];
           yt=[yt; Y(i)];
       end    
    end
    
    z = zeros(size(y,1), 3);
    
    for i=1:size(y,1)
        if y(i)==1
            z(i,:)=[1 0 0];
        elseif y(i)==2
            z(i,:)=[0 1 0];
        elseif y(i)==3
            z(i,:)=[0 0 1];
        end
    end
    
    zp = zeros(size(yt,1), 3);
    yp = zeros(size(yt,1), 1);

    m=size(x,1);
    n=size(x,2);
    yp=zeros(size(xt,1),1);
    %--------------------------------------
    for c=1:3
        iter=100;
        alpha=0.05;
        W = rand(1,n);
        h = zeros(size(x,1),1);
        
        h=exp(-(x*W'));
        for i=1:size(x,1)
            h(i) = 1/(1+h(i)); 
        end
        
        for t=1:iter 
            dec = (z(:,c).*(ones(size(x,1),1)-h) - (ones(size(x,1),1)-z(:,c)).*(h))' * x;
            W= W - alpha*1/size(x,1)*(sum(dec) ) ;   
   
            h=exp(-(x*W'));
            for i=1:size(x,1)
                h(i) = 1/(1+h(i)); 
            end  
        end
        
        zp(:,c) = exp(-(xt*W'));
        for i=1:size(xt,1)
            zp(i,c) = 1/(1+zp(i,c));
        end   
        %test cases running
    end
    %----------------------------------------------
    for i=1:size(xt,1)
        if(zp(i,1)>zp(i,2))
            if(zp(i,1)>zp(i,3))
                yp(i)=1;
            else
                yp(i)=3;
            end
        else
            if(zp(i,2)>zp(i,3))
                yp(i)=2;
            else
                yp(i)=3;
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
    acc = (ConfMat(1,1)+ConfMat(2,2)+ConfMat(3,3))/(ConfMat(1,1)+ConfMat(1,2)+ConfMat(2,1)+ConfMat(2,2));
    fprintf("Overall Accuracy = %f\n",acc);
    acc_mean = acc_mean + acc;
    fprintf("Individual Accuracy:\n");
    fprintf("Class 1: %f\n",ConfMat(1,1)/(ConfMat(1,1)+ConfMat(1,2)+ConfMat(1,3)) );
    fprintf("Class 2: %f\n",ConfMat(2,2)/(ConfMat(2,1)+ConfMat(2,2)+ConfMat(2,3)) );
    fprintf("Class 3: %f\n",ConfMat(3,3)/(ConfMat(3,1)+ConfMat(3,2)+ConfMat(3,3)) );
end    
acc_mean = acc_mean/5;
fprintf("Accuracy = %f\n",acc_mean);
