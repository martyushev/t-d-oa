% minimal residual over all solutions for ToA problem
function min_res = residual(Se,Re,Sgt,Rgt)

    min_res = Inf;
    for r = 1:size(Se,3)
        res = norm(Se(:,:,r) - Sgt,'fro')^2 + norm(Re(:,:,r) - Rgt,'fro')^2;
        if res < min_res; min_res = res; end
    end
    min_res = sqrt(min_res);

end