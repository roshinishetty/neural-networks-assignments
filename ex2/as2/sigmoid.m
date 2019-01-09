function s = sigmoid(x)
s=exp(-x);
for i=1:length(s)
    s(i)=1/(1+s(i));
end
end