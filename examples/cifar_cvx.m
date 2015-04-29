clear
% load('info_d_new.mat')
% P = zeros(10*10000, 4000);
% Y = zeros(10, 10000);
load('P.mat')
load('Y.mat')

% for i = 1:length(info.prob)    
%     for j = 1:4000
%         tmp = info.prob{i}{j}(:);
%         P((i-1)*1000+1:i*1000,j) = tmp;
%     end
%     for k = 1:100
%         temp = zeros(10,1);
%         temp(info.labels{i}(k)) = 1;
%         Y(:,(i-1)*100+k) = temp;
%     end
% end
% P_n = reshape(P, 1000,100);
Y = reshape(Y, 10000*10,1);
lambda = 0.1;

% cvx_begin
%     variables w1(1) w2(1)
%     minimize 1/2*norm(w1*P(:,1)+w2*P(:,2)-Y) +lambda * (norm(w1) + norm(w2))
%     subject to 
%         w1 >= 0;
%         w2 >= 0;
% cvx_end

cvx_begin
    variables w(4000)
    minimize transpose(w)*transpose(P)*P*w- 2*transpose(Y)*P*w + transpose(Y)*Y  +lambda * (norm(w))
    subject to 
        w >= 0;
cvx_end

Pw = P * w;
Pwr = reshape(Pw, 10, 10000);
Yr = reshape(Y,10,10000);
[~,IYr] = max(Yr);
[~,IPwr] = max(Pwr);
Err = zeros(1,10000);
Err(IYr ~= IPwr) = 1;
sum(Err)