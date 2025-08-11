% error metric to estimate performance of ToA solvers
function min_err = error_toa(Se,Re,Sgt,Rgt)
    m = size(Sgt,2);
    n = size(Rgt,2);
    min_err = Inf;
    for r = 1:size(Se,3)
        err = 0;
        for i = 1:m
            for j = i+1:m
                err = err + (norm(Sgt(:,i)-Sgt(:,j),'fro') - norm(Se(:,i,r)-Se(:,j,r),'fro'))^2;
            end
        end
        for k = 1:n
            for l = k+1:n
                err = err + (norm(Rgt(:,k)-Rgt(:,l),'fro') - norm(Re(:,k,r)-Re(:,l,r),'fro'))^2;
            end
        end
        if err<min_err; min_err = err; end
    end
    min_err = sqrt(min_err);
end