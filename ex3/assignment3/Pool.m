function y = Pool(x)

[numFilters, xcol] = size(x);
if mod(xcol,2)==1
    for i=1:numFilters
        x(i,xcol+1)=0;
    end
    xcol = xcol+1;
end

y = zeros(numFilters, xcol/2);

for k=1:numFilters
    for i=1:xcol/2           
        y(k,i) = (x(k,2*i-1) + x(k,2*i))/2;
    end    
end    

end