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
addpath(genpath(fullfile(MyPhysicsPath,'MESH')));
addpath(genpath(fullfile(MyPhysicsPath,'Matrices')));
addpath('~/petsc/share/petsc/matlab');

%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
% First I have generated the meshes for every N,it's the most expensive step
% Then I read that meshes and use different polynomial degrees.
dataset = readtable('InputData.csv');
h_vec = zeros(height(dataset),1);

% Mesh Generation
% if isempty(gcp('nocreate'))
%     parpool(4);
% end
loc = 'Matrices/';
DataTestLap;

for j = 1:height(dataset)
    
    Data.N = dataset.N(j);
    Data.degree = dataset.p(j);
    ii = dataset.ID(j);
    fprintf("========= Case id: %d =========", ii);
    Data.mu = {str2func(dataset.mu{j})}; 
    Data.source = {str2func([dataset.mu{j}, '.*',dataset.f{j}])};
    Data.DirBC  = {str2func(dataset.g{j})};
    name = [num2str(Data.N), '_el.mat'];

    Data.meshfile = fullfile(Data.FolderName, name);

    [Matrices, F, h] = DataGenerator(Data,Setup);
    PetscBinaryWrite([loc, 'A', num2str(ii) ,'.dat'], sparse(Matrices.A));
    PetscBinaryWrite([loc, 'F', num2str(ii) ,'.dat'], F);
    h_vec(j) = h;
end

dataset.h = h_vec;
writetable(dataset, 'dati.csv');
%if Data.MeshFromFile
    % Load existing mesh
    %Data.meshfile = fullfile(Data.FolderName, Data.meshfileseq);
%else
    % Create a new mesh
    % if isempty(gcp('nocreate'))
    %     parpool(4);
    % end
    % 
    % parfor i=1:5 % This generate the 5 meshes
    %     MakeMeshMonodomain(Data,N(i),Data.domain,Data.FolderName,meshname,'P','laplacian');
    % end
%end
% 
% Main
% [Matrices, F, Data] = DataGenerator(Data,Setup);
% 
% % Send to PETSC
% loc = 'Matrices/';
% PetscBinaryWrite([loc, 'A', num2str(id) ,'.dat'], sparse(Matrices.A));
% PetscBinaryWrite([loc, 'F', num2str(id) ,'.dat'], F);
% 
% T = table(Data.N, Data.h , Data.p, 2, ...
%     'VariableNames', {'N', 'h','p', 'mu', 'f(x,y)', 'g(x,y)'});
%      writetable(T, 'dati.csv');
