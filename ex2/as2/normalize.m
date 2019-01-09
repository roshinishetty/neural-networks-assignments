function X = normalize(X,k)
m=size(X,1);
n=size(X,2);
for j=k:n
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
end