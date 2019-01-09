function y = Conv(x, W)
    
[numFilters, wcol] = size(W);
[~, xcol] = size(x);

ycol = xcol - wcol + 1;

y = zeros(numFilters, ycol);

for k =1:numFilters
   filter = W(k,:);
   for i=1:ycol
        for j =1:wcol
            y(k,i) = y(k,i) + filter(j)*x(i+j-1); 
        end
   end     
end    

end