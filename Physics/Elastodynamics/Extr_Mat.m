N = Data.N;
T = Data.T;

% file_A = fopen('Output/matrix_A.dat', 'w');
% fwrite(file_A, full(Matrices.Ela.A_E), 'double');
% fclose(file_A);
% 
% file_b = fopen('Output/vector_b.dat', 'w');
% fwrite(file_b, Matrices.F, 'double');
% fclose(file_b); 

% file_uh = fopen('Output/vector_uhm.dat', 'w');
% fwrite(file_uh, U_h(1:601), 'double');
% fclose(file_uh); 
% 
% file_uh = fopen('Output/vector_uex.dat', 'w');
% fwrite(file_uh, Matrices.U_ex, 'double');
% fclose(file_uh); 
dest = "/home/cristian/Desktop/Polimi/Shared_data/Quarto Anno/NAPDE/PROG/Prova_PETSc3/Files/";
WritePetscMat(dest + 'matrix_A.dat', Matrices.Ela.A_E);
WritePetscVec(dest + 'vector_b.dat', Matrices.F);
WritePetscVec(dest + 'vector_uex.dat', Matrices.U_ex);
WritePetscVec(dest + 'vector_uhm.dat', U_h(1:600));
  