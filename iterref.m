% iterative refinement
function [S1,R1,res,d_min] = iterref(S,R,D)

    opts = optimoptions('fsolve', 'Display', 'off', 'Algorithm', 'levenberg-marquardt', 'StepTolerance', 1e-12, 'FunctionTolerance', 1e-12);
    nr = size(S,3);
    d = size(S,1);
    res = nan(nr,1);
    S1 = S;
    R1 = R;
    for i = 1:nr
        X0 = SR2X(S(:,:,i),R(:,:,i),d);
        [X1,~,~] = fsolve(@(X) resid(X,D,d),X0,opts);
        [S1(:,:,i),R1(:,:,i)] = X2SR(X1,d);
        res(i) = max(abs(resid(X1,D,d)));
    end
    
    if d==2
        c = all(S1(1,2,:)>0 & S1(2,3,:)>0, 1);
    elseif d==3
        c = all(S1(1,2,:)>0 & S1(2,3,:)>0 & S1(3,4,:)>0, 1);
    end
    S1 = S1(:,:,c);
    R1 = R1(:,:,c);
    nr = size(S1,3);

    d_min = Inf;
    for i = 1:nr
        for j = i+1:nr
            d = norm(S1(:,:,i) - S1(:,:,j), 'fro')^2 + norm(R1(:,:,i) - R1(:,:,j), 'fro')^2;
            if d < d_min; d_min = d; end
        end
    end

end



function X = SR2X(S,R,d)
    if d==2
        X = [S(1,2:3), S(2,3), R(1,1:3), R(2,1:3)];
    elseif d==3
        X = [S(1,2:4), S(2,3:4), S(3,4), R(1,1:6), R(2,1:6), R(3,1:6)];
    end
end



function [S,R] = X2SR(X,d)
    if d==2
        S = [0 X(1:2); 0 0 X(3)];
        R = [X(4:6); X(7:9)];
    elseif d==3
        S = [0 X(1:3); 0 0 X(4:5); 0 0 0 X(6)];
        R = [X(7:12); X(13:18); X(19:24)];
    end
end



function res = resid(X,D,d)
    [S,R] = X2SR(X,d);
    m = size(S,2);
    n = size(R,2);
    res = nan(n,m);
    for i = 1:m
        for k = 1:n
            dSR = S(:,i) - R(:,k);
            res(k,i) = dSR.'*dSR - D(k,i);
        end
    end
    res = res(:);
end