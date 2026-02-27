%> @file  RunMainLaplacian.m
%> @author The Lymph Team
%> @date 16 April 2023
%> @brief Run of MainLaplacian for the solution of the Poisson problem
%>
%==========================================================================
%> @section classRunMainLaplacian Class description
%==========================================================================
%> @brief            Run of MainLaplacian
%
%> @param ~
%>
%> @retval ~
%>
%==========================================================================

%% Import lymph and paths of folders related to this problem
run("../ImportLymphPaths.m")
MyPhysicsPath = pwd;
addpath(genpath(fullfile(MyPhysicsPath,'Assembly')));
addpath(genpath(fullfile(MyPhysicsPath,'InputData')));
addpath(genpath(fullfile(MyPhysicsPath,'MainFunctions')));
addpath(genpath(fullfile(MyPhysicsPath,'Error')));
addpath(genpath(fullfile(MyPhysicsPath,'PostProcessing')));
addpath('/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/petsc/share/petsc/matlab');

%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
DataTestLap;

%% Mesh Generation

if Data.MeshFromFile
    % Load existing mesh
    Data.meshfile = fullfile(Data.FolderName, Data.meshfileseq);
else
    % Create a new mesh
    Data.meshfile = MakeMeshMonodomain(Data,Data.N,Data.domain,Data.FolderName,Data.meshfileseq,'P','laplacian');
end

%% Main
[Error, Matrices, F, U] = MainLaplacian(Data,Setup);

%% Send to PETSC
fprintf('\nWriting Matrices in PETSC ... ');
loc = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/FilesLap/';
if ~Data.MeshFromFile
    PetscBinaryWrite([loc, 'A_', num2str(Data.N),'p',num2str(Data.degree) ,'.dat'], sparse(Matrices.A));
    PetscBinaryWrite([loc, 'F_', num2str(Data.N),'p',num2str(Data.degree) ,'.dat'], F);
    PetscBinaryWrite([loc, 'Um_', num2str(Data.N),'p',num2str(Data.degree) ,'.dat'], U);
else 
    PetscBinaryWrite([loc, 'A_19600', 'p',num2str(Data.degree) ,'.dat'], sparse(Matrices.A));
    PetscBinaryWrite([loc, 'F_19600', 'p',num2str(Data.degree) ,'.dat'], F);
    PetscBinaryWrite([loc, 'Um_19600','p',num2str(Data.degree) ,'.dat'], U);
end
fprintf('\nDone\n')
fprintf('\n------------------------------------------------------------------\n')
