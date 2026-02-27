run("../ImportLymphPaths.m")
MyPhysicsPath = pwd;
addpath(genpath(fullfile(MyPhysicsPath,'Assembly')));
addpath(genpath(fullfile(MyPhysicsPath,'Error')));
addpath(genpath(fullfile(MyPhysicsPath,'InputData')));
addpath(genpath(fullfile(MyPhysicsPath,'InputMesh')));
addpath(genpath(fullfile(MyPhysicsPath,'MainFunctions')));
addpath(genpath(fullfile(MyPhysicsPath,'PostProcessing')));
addpath(genpath(fullfile(MyPhysicsPath,'TimeIntegration')));
addpath('/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/petsc/share/petsc/matlab');
dest = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/Files/';
%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
DataTestEla;
%% 
polys = [1, 2, 3];
Ns    = [300, 500, 800];

for N = Ns
    Data.N = N;
    for p = polys
        Data.degree = p;
        Data.meshfile = MakeMeshMonodomain(Data,Data.N,Data.domain,Data.FolderName,Data.meshfileseq,'P','ela');
        [C, U_h, F] = MainEla(Data,Setup);
        fprintf('\nWriting Matrices in PETSC ... ');
        PetscBinaryWrite([dest, 'A_', num2str(Data.N), '_p', num2str(Data.degree), '.dat'], sparse(C));
        PetscBinaryWrite([dest, 'F_', num2str(Data.N), '_p', num2str(Data.degree), '.dat'], F);
        PetscBinaryWrite([dest, 'Um_', num2str(Data.N), '_p', num2str(Data.degree),'.dat'], U_h);
        fprintf('\nDone\n')
        fprintf('\n------------------------------------------------------------------\n')
    end

end