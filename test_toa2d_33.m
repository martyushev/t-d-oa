m = 3; % number of senders
n = 3; % number of receivers
Sgt = rand(2,m); % ground truth senders
Rgt = rand(2,n); % ground truth receivers

D = zeros(n,m); % squared distances
for i = 1:m
    for k = 1:n
        D(k,i) = (Sgt(:,i)-Rgt(:,k))'*(Sgt(:,i)-Rgt(:,k));
    end
end

tic;
[Se,Re] = solver_toa2d_33(D);
tm = toc;

err = error_toa(Se,Re,Sgt,Rgt);

for i = 1:size(Se,3)
    fprintf('%s%d:\n', 'Solution #', i);
    disp([Se(:,:,i), Re(:,:,i)]);
end
fprintf('%s%g\n', 'Error: ', err);
fprintf('%s%.2f%s\n', 'Time: ', 10^3*tm, ' ms');