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
addpath(genpath(fullfile(MyPhysicsPath,'BIG_MESHES')));
addpath(genpath(fullfile(MyPhysicsPath,'Matrices')));

%% Simulation - Setup
run("../RunSetup.m")
bot = Bot();
%% Input Data - Boundary conditions - Forcing term
% First I have generated the meshes for every N,it's the most expensive step
% Then I read that meshes and use different polynomial degrees.
DataTestLap;
% Mesh Generation

N = [3:2:17]' .* 10^3;
fprintf(1, 'Starting to generate meshes [%s]\n', datestr(now));
fprintf(1, '================================\n');
message = "JOB STARTS: I'm generating the meshes";
bot.send_message(message);
%logfile = fullfile(pwd, 'generate_meshes_runtime.log');
%fid = fopen(logfile, 'a');
%fprintf(fid, '\n===== JOB START %s =====\n', datestr(now));
%fclose(fid);

% Legge il numero di core assegnati da PBS (variabile d'ambiente)
nCores = str2double(getenv('NCPUS'));
if isnan(nCores)
    nCores = 4; 
end 

if isempty(gcp('nocreate'))
    parpool(nCores);
end

parfor i=1:length(N) % This generate the meshes
    %fprintf("============== Start MESH N = %d ==============\n", N(i));
    fprintf(1, 'Worker %d starting mesh N = %d at %s\n', getCurrentTask().ID, N(i), datestr(now));
    %fid = fopen(logfile, 'a');
    %fprintf(fid, 'Worker %d starting mesh N = %d at %s\n', getCurrentTask().ID, N(i), datestr(now));
    %fclose(fid);

    MakeMeshMonodomain(Data,N(i),Data.domain,Data.FolderName,'','P','laplacian');

    %fid = fopen(logfile, 'a');
    %fprintf(fid, 'Worker %d finished mesh N = %d at %s\n', getCurrentTask().ID, N(i), datestr(now));
    %fclose(fid);
    fprintf(1, 'Worker %d finished mesh N = %d at %s\n', getCurrentTask().ID, N(i), datestr(now));
    
end

fprintf(1, '\n============== ALL MESHES GENERATED ==============\n');
bot.send_message('ALL MESHES GENERATED'); 
