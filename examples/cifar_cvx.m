% clear
% load('info_d_10000.mat')
P = zeros(10*10000, 4000);
Y = zeros(10, 10000);
% load('P.mat')
% load('Y.mat')

for i = 1:length(info.prob)    
    for j = 1:4000
        tmp = info.prob{i}{j}(:);
        P((i-1)*1000+1:i*100000,j) = tmp;
    end
    for k = 1:10000
        temp = zeros(10,1);
        temp(info.labels{i}(k)) = 1;
        Y(:,(i-1)*100+k) = temp;
    end
end
% P_n = reshape(P, 1000,100);
Y = reshape(Y, 10000*10,1);
lambda = 0.1;



k1 = 1200;
k2 = 3000;
% 
% 
% 
% cvx_begin
%     variables w1(1) w2(1)
%     minimize 1/2*norm(w1*P(:,k1)+w2*P(:,k2)-Y) +lambda * (norm(w1) + norm(w2))
%     subject to 
%         w1 >= 0;
%         w2 >= 0;
% cvx_end
% 
P1 = reshape(P(:,k1), 10, 10000);
P2 = reshape(P(:,k2), 10, 10000);
[~,IP1] = max(P1);
[~,IP2] = max(P2);
Err1 = zeros(1,10000);
Err2 = zeros(1,10000);
Err1(IYr ~= IP1) = 1;
Err2(IYr ~= IP2) = 1;
sum(Err1)
sum(Err2)
Ps = w1*P(:,k1)+w2*P(:,k2);
Psr = reshape(Ps, 10, 10000);
[~,IPsr] = max(Psr);
Errs = zeros(1,10000);
Errs(IYr ~= IPsr) = 1;
sum(Errs)


d = 2;
Pd = P(:,1:d);

cvx_begin
    variables w(d)
    minimize transpose(w)*transpose(Pd)*Pd*w- 2*transpose(Y)*Pd*w + transpose(Y)*Y  +lambda * (norm(w))
    subject to 
        w >= 0;
cvx_end

Pw = Pd * w;
Pwr = reshape(Pw, 10, 10000);
Yr = reshape(Y,10,10000);
[~,IYr] = max(Yr);
[~,IPwr] = max(Pwr);
Err = zeros(1,10000);
Err(IYr ~= IPwr) = 1;
sum(Err)