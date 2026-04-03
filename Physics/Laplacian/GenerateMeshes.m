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
addpath(genpath(fullfile(MyPhysicsPath,'BIG_MESH')));
addpath(genpath(fullfile(MyPhysicsPath,'Matrices')));
addpath('~/petsc/share/petsc/matlab');

%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
% First I have generated the meshes for every N,it's the most expensive step
% Then I read that meshes and use different polynomial degrees.
DataTestLap;
% Mesh Generation

N = [10:1.5:19, 21]' .* 10^3;

if Data.MeshFromFile
    %Load existing mesh
    Data.meshfile = fullfile(Data.FolderName, Data.meshfileseq);
else
    %Create a new mesh
    if isempty(gcp('nocreate'))
        parpool(4);
    end
    parfor i=1:length(N) % This generate the 5 meshes
        MakeMeshMonodomain(Data,N(i),Data.domain,Data.FolderName,'','P','laplacian');
    end

end

