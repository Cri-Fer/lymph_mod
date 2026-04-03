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

%% Simulation - Setup
run("../RunSetup.m")

%% Input Data - Boundary conditions - Forcing term
% First I have generated the meshes for every N,it's the most expensive step
% Then I read that meshes and use different polynomial degrees.
DataTestLap;
% Mesh Generation

N = [10:1.5:19, 21]' .* 10^3;
% fprintf("Starting to generate meshes\n");
% fprintf("================================\n");

logfile = fullfile(pwd, 'generate_meshes_runtime.log');
fid = fopen(logfile, 'a');
fprintf(fid, '\n===== JOB START %s =====\n', datestr(now));
fclose(fid);

% Legge il numero di core assegnati da PBS (variabile d'ambiente)
nCores = str2double(getenv('NCPUS'));
if isnan(nCores), nCores = 4; end % Default se lanciato localmente

if isempty(gcp('nocreate'))
    parpool(nCores);
end

parfor i=1:length(N) % This generate the meshes
    fprintf("============== Start MESH N = %d ==============\n", N(i));

    fid = fopen(logfile, 'a');
    fprintf(fid, 'Worker starting mesh N = %d at %s\n', N(i), datestr(now));
    fclose(fid);

    MakeMeshMonodomain(Data,N(i),Data.domain,Data.FolderName,'','P','laplacian');

    fid = fopen(logfile, 'a');
    fprintf(fid, 'Worker starting mesh N = %d at %s\n', N(i), datestr(now));
    fclose(fid);

	fprintf("\n============== End MESH N = %d ==============\n", N(i));
end

