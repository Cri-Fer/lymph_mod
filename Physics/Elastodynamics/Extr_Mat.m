N = Data.N;
T = Data.T;
addpath("/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/petsc/share/petsc/matlab");

dest = "/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/Files";
WritePetscMat(dest + 'matrix_A.dat', Matrices.Ela.A_E);
WritePetscVec(dest + 'vector_b.dat', Matrices.F);
% WritePetscVec(dest + 'vector_uex.dat', Matrices.U_ex);
destin = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/Files/vector_uhm.dat';
PetscBinaryWrite(destin, U_h(1:length(U_h)/2));
% WritePetscVec(dest + 'vector_uhm.dat', U_h(1:length(U_h)/2));
  