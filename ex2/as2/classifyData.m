function Z = classifyData(Y)
    Z = zeros(size(Y,1), 3);
    for i=1:size(Y,1)
        if Y(i)==1
             Z(i,:)= [1 0 0];
        elseif Y(i)==2
             Z(i,:) = [0 1 0];
        elseif Y(i)==3
             Z(i,:) = [0 0 1];
        end    
    end
end