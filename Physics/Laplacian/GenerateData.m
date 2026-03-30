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
addpath(genpath(fullfile(MyPhysicsPath,'Matrices')));
addpath('/home/cri/petsc/share/petsc/matlab');

%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
sources = [{@(x,y) 8*pi^2 * sin(2*pi*x).* cos(2*pi*y)}];
BCs     = [{@(x,y) (x.^2+y).^1.5}];

DataTestLap;
Data.N = 100;
Data.p = 1;
Data.mu = {@(x,y) 2};
Data.source = sources(1);
Data.DirBC = BCs(1);
i = 1;
% Mesh Generation

if Data.MeshFromFile
    % Load existing mesh
    Data.meshfile = fullfile(Data.FolderName, Data.meshfileseq);
else
    % Create a new mesh
    Data.meshfile = MakeMeshMonodomain(Data,Data.N,Data.domain,Data.FolderName,Data.meshfileseq,'P','laplacian');
end

% Main
[Matrices, F] = DataGenerator(Data,Setup);

% Send to PETSC
loc = 'Matrices/';
PetscBinaryWrite([loc, 'A_', num2str(i) ,'.dat'], sparse(Matrices.A));
PetscBinaryWrite([loc, 'F_', num2str(i) ,'.dat'], F);
T = table(Data.N, Data.p, 2, ...
    'VariableNames', {'N', 'p', 'mu'});
     writetable(T, 'dati.csv');
