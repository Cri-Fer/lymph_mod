%> @file  RunMainEla.m
%> @author The Lymph Team
%> @date 24 July 2024
%> @brief Run of MainEla for the solution of the elstodynamics problem
%>
%==========================================================================
%> @section classRunMainEla Class description
%==========================================================================
%> @brief            Run of MainEla
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
addpath(genpath(fullfile(MyPhysicsPath,'Error')));
addpath(genpath(fullfile(MyPhysicsPath,'InputData')));
addpath(genpath(fullfile(MyPhysicsPath,'InputMesh')));
addpath(genpath(fullfile(MyPhysicsPath,'MainFunctions')));
addpath(genpath(fullfile(MyPhysicsPath,'PostProcessing')));
addpath(genpath(fullfile(MyPhysicsPath,'TimeIntegration')));
addpath(genpath(fullfile(MyPhysicsPath,'Output')));
addpath('/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/petsc/share/petsc/matlab');
%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
DataTestEla;
%DataTestPhysicsEla;

%% Mesh Generation
if Data.MeshFromFile
    % Load existing mesh
    Data.meshfile = fullfile(Data.FolderName, Data.meshfileseq);
else
    % Create a new mesh
    Data.meshfile = MakeMeshMonodomain(Data,Data.N,Data.domain,Data.FolderName,Data.meshfileseq,'P','ela');
end

%% Main
%[C, U_h, F] = MainEla(Data,Setup);
%dest = '/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/Files/';
%fprintf('\nWriting Matrices in PETSC ... ');
%PetscBinaryWrite([dest, 'A_', num2str(Data.N), '_p', num2str(Data.degree)], C);
%PetscBinaryWrite('/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/FilesLap/F.dat', F);
%PetscBinaryWrite('/home/cristian/Desktop/Polimi/NAPDE/PROG/Condividere/Conv/FilesLap/Um.dat', U_h);

%% Main
MainEla_nosol_staticcase(Data,Setup);
%[Error, Matrices, U_h] = MainEla(Data,Setup); %se voglio trovare soluzione

fprintf('\nDone\n')
fprintf('\n------------------------------------------------------------------\n')
