clear; clc;

toaType = 1;
% 1:   2D 3s/3r
% 2:   3D 4s/6r
% 101: 2D 3s/3r with 8 real solutions
% 102: 3D 4s/6r with 20 real solutions

itRef = 0;
% 1/0: iterative refinement on/off

toa = genTOA(toaType);

tic;
[Se,Re,err] = feval(toa.solver,toa.D,itRef);
tm = toc;

for i = 1:size(Se,3)
    fprintf('\nSolution #%d:\n', i);
    disp([Se(:,:,i), Re(:,:,i)]);
    fprintf('Error: %.6g\n', err(i));
end
fprintf('\nGround truth:\n');
disp([toa.Sgt toa.Rgt]);
fprintf('Residual: %.6g\n', residual(Se,Re,toa.Sgt,toa.Rgt));
fprintf('\nTime: %.2f ms\n', 10^3*tm);