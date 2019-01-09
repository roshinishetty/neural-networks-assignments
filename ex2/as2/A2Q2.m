clc;
clear;
close all;

d = xlsread('dataset.xlsx');

X = d(:,(1:7));
R = d(:,8);
classes=3;

X = [ones(size(X,1),1) X];
R = classifyData(R);    

X = normalize(X, 2);
[X,R,Xt,Rt] = CrossValidation(X,R);

m=length(X);
I=7;
O=3;

max = 0;

for H=2:1:5
    for alpha=0.2:0.05:0.5
        V = -0.01 + 0.02*rand(O,H+1);
        W = -0.01 + 0.02*rand(H,I+1);
        Z(1)=0.0001;
        
        for iter=1:100
            for t=randperm(m)
                
                for h=1:H
                    Z(h+1) = sigmoid( act( W(h,:), X(t,:) ) );
                end
                
                for i=1:O
                    Y(i) = sigmoid( act( V(i,:), Z ) );
                end
                
                for i=1:O
                    for h=1:H
                        del_V(i,h) = -alpha*(R(t,i)-Y(i))*Y(i)*(1-Y(i))*Z(h);
                    end
                end    
                
                for h=2:H
                    for j=1:I
                        sum=0;
                        for i=1:O
                            sum=sum+(R(t,i) - Y(i))*V(i,h);
                        end    
                        del_W(h,j)=-alpha*sum*Z(h)*(1-Z(h))*X(t,j);
                    end
                end
                
               for i=1:O
                    for h=1:H
                        V(i,h) = V(i,h) - del_V(i,h); 
                    end
                end    
                
                for h=1:H
                    for j=1:I
                        W(h,j) = W(h,j) - del_W(h,j);
                    end
                end
                
            end
        end
        
        acc = 0;
        for t=1:size(Xt,1)
            Zt(t,1) = Z(1);
            for h=2:H+1
                Zt(t,h) = sigmoid( act( W(h-1,:), Xt(t,:) ) );
            end
            
            maxi = 0;
            for i=1:O
                Yp(t,i) = sigmoid( act( V(i,:), Zt(t,:) ) );
                if maxi < Yp(t,i)
                    maxi = Yp(t,i);
                    Zp(t) = i; 
                end    
            end 
        end
        
        for t=1:size(Xt,1)
            if Zp(t)==Rt(t)
                acc = acc +1;
            end
        end
        
        if acc > max
            max = acc;
            maxH = H;
            maxA = alpha;
        end    
        %test it now
    end
end    
fprintf("Max accuracy is acheived at:\n Hidden layers=%d\n alpha = %f\n",maxH,maxA);
fprintf("Max accuracy=%f\n Hidden layers=%f\n alpha = %f\n",max/size(Xt,1),maxH,maxA);