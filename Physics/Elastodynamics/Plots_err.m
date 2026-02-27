err_loc = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/err/ela/';

e1 = PetscBinaryRead([err_loc, 'err_L2_300_p1.dat']);
e2 = PetscBinaryRead([err_loc, 'err_L2_300_p2.dat']);
e3 = PetscBinaryRead([err_loc, 'err_L2_300_p3.dat']);
e4 = PetscBinaryRead([err_loc, 'err_L2_500_p1.dat']);
e5 = PetscBinaryRead([err_loc, 'err_L2_500_p2.dat']);
e6 = PetscBinaryRead([err_loc, 'err_L2_500_p3.dat']);
e7 = PetscBinaryRead([err_loc, 'err_L2_800_p1.dat']);
e8 = PetscBinaryRead([err_loc, 'err_L2_800_p2.dat']);
e9 = PetscBinaryRead([err_loc, 'err_L2_800_p3.dat']);

residual = [1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10, 1e-12, 1e-14, 1e-16, 1e-20]';

figure()
loglog(residual, e7, 'r*-', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerEdgeColor', '#00841a')
hold on
% loglog(residual, e2, 'b*-', 'LineWidth', 1)
% loglog(residual, e3, 'k*-', 'LineWidth', 1)
%loglog(residual, e4, 'c -o', 'LineWidth', 1)
%loglog(residual, e5, 'm -o', 'LineWidth', 1)
%loglog(residual, e6, 'b -o', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerEdgeColor', '#00841a')
%loglog(residual, e7, 'k -x', 'LineWidth', 2)
loglog(residual, e8, 'c -x', 'LineWidth', 2)
loglog(residual, e9, 'm -x', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerEdgeColor', '#00841a')
legend("800 p1", "800 p2", "800 p3")
grid on