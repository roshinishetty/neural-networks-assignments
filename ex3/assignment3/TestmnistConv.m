load('data_for_cnn.mat');
load('class_label.mat');

rng(1);

W1 = 1e-2*randn([20 9]);
W5 = (2*rand(20, 9920) - 1) * sqrt(6) / sqrt(500+20);
Wo = (2*rand(1, 20) -1) * sqrt(6) / sqrt(20+1);

for epoch = 1:3
    epoch

   alpha = 0.01;
   beta = 0.95;
   lambda = 0.01;
   
momentum1 = zeros(size(W1));
momentum5 = zeros(size(W5));
momentumo = zeros(size(Wo));

N = length(label);

bsize = 100;
blist = 1:bsize:(N-bsize+1);

for batch = 1:length(blist)
   dW1 = zeros(size(W1));
   dW5 = zeros(size(W5));
   dWo = zeros(size(Wo));
   
   begin = blist(batch);
   for k = begin:begin+bsize-1
      x = ecg_in_window(k,:);
      y1 = Conv(x, W1);
      y2 = ReLU(y1);
      y3 = Pool(y2);
      y4 = reshape(y3, [], 1);
      v5 = W5*y4;
      y5 = ReLU(v5);
      v =  Wo*y5;
      y = softmax(v);
      
      d = label(k,:);
      
      e = (d - y);
      delta = e;% * y * (1-y);
  
      e5 = Wo' * delta;
      delta5 = (y5 > 0).*e5;
      e4 = W5' * delta5;
      
      dWo = y * delta;
      dW5 = y5 .* delta5;
      
      Wo = (1-alpha*lambda)*Wo - alpha*dWo;
      W5 = (1-alpha*lambda)*W5 - alpha*dW5;
      
      e3 = reshape(e4, size(y3));
      e2 = zeros(size(y2));
      W3 = ones(size(y2))/2;
      
      for c =1:20
         e2(c,:) = kron(e3(c,:), ones([1 2])) .* W3(c,:); 
      end
      
      delta2 = (y2>0) .* e2;
      delta1_x = zeros(size(W1));
      
      for c=1:20
        for i=1:size(delta1_x,2)
            for j =1:size(delta2,2)
               delta1_x(c,i) = delta1_x(c,i) + delta2(c,j)*x(i+j-1); 
            end
        end 
      end
      
      dW1 = dW1 + delta1_x;
      dW5 = dW5 + delta5*y4';
      dWo = dWo + delta*y5';
      
   end    
   
   dW1 = dW1 / bsize;
   dW5 = dW5 / bsize;
   dWo = dWo / bsize;

   momentum1 = alpha*dW1 + beta*momentum1;
   W1        = W1 + momentum1;
   
   momentum5 = alpha*dW5 + beta*momentum5;
   W5        = W5 + momentum5;
   
   momentumo = alpha*dWo + beta*momentumo;
   Wo        = Wo + momentumo;   
   
end
end
save('MnistConv.mat');

X = ecg_in_window(251:750, :);
D = label(251:750, :);
acc = 0;
N = length(D);

yp = -1*ones(N,1);

for k= 1:N
   x = X(k, :);
   y1 = Conv(x, W1);
   y2 = ReLU(y1);
   y3 = Pool(y2);
   y4 = reshape(y3, [], 1);
   v5 = W5*y4;
   y5 = ReLU(v5);
   v = Wo*y5;
   y = softmax(v);
   
   [~, i] = max(y);
   yp(k) = i;
   if i ==D(k)
       acc = acc +1.875;
   end    
end   

acc = acc / N*100;
fprintf("Accuracy is %f\n", acc);