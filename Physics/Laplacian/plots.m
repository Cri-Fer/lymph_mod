%% Convergence plot: iterative -> direct as residual -> 0
% We are inside the laplacian folder, so the loc is referred to the
% laplacin folder in the C++ code

addpath("/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/petsc/share/petsc/matlab");
loc = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/err/lap/';

err1 = PetscBinaryRead([loc, 'err_L2_196000_1deg.dat']);
err2 = PetscBinaryRead([loc, 'err_L2_1000_1deg.dat']);
err3 = PetscBinaryRead([loc, 'err_L2_1000_3deg.dat']);
err4 = PetscBinaryRead([loc, 'err_L2_1000_5deg.dat']);
err5 = PetscBinaryRead([loc, 'err_L2_196000_3deg.dat']);
err6 = PetscBinaryRead([loc, 'err_L2_500p1.dat']);
err7 = PetscBinaryRead([loc, 'err_L2_500p3.dat']);
err8 = PetscBinaryRead([loc, 'err_L2_500p5.dat']);

residual = [1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10, 1e-12, 1e-14, 1e-16, 1e-20]';


figure()
loglog(residual, err1, 'ro-', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', '#00841a')
hold on
loglog(residual, err5, 'ro--', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', '#00841a')
loglog(residual, err2, 'ko-', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerEdgeColor', '#00841a')
loglog(residual, err3, 'k*--', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerEdgeColor', '#00841a')
loglog(residual, err4, 'k*-.', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerEdgeColor', '#00841a')
%loglog(residual, err6, 'bx-.', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', '#00841a')
% loglog(residual, err7, 'k*-.', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', '#00841a')
% loglog(residual, err8, 'c*-.', 'LineWidth', 2, 'MarkerSize', 10, 'MarkerEdgeColor', '#00841a')
grid on

%legend("500 p=3", "1000 p=3", "196000 p=3")

legend("196000 p=1", "196000 p=3", "1000 p=1", "1000 p=3", "1000 p=5") ...
%       "500 p=1", "500 p=3", "500 p=5")
