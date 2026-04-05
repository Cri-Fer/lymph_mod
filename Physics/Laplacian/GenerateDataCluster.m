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

if ~isfolder('Matrices/')
    mkdir('Matrices/')
end

addpath(genpath(fullfile(MyPhysicsPath,'Matrices')));
addpath('/usr/lib/petscdir/petsc3.19/x86_64-linux-gnu-real/share/petsc/matlab');
%addpath('~/petsc/share/petsc/matlab');

%% Simulation - Setup
run("../RunSetup.m")

%% Initialize Telegram Bot
bot = Bot();

%% Input Data - Boundary conditions - Forcing term
% First I have generated the meshes for every N,it's the most expensive step
% Then I read that meshes and use different polynomial degrees.
dataset = readtable('InputData.csv');
h_vec = zeros(height(dataset),1);
dataset.A_name = strings(height(dataset),1);
dataset.F_name = strings(height(dataset),1);
% We save id; pb_id; N, h, p, ndof, nnz, A_name, F_name
output = table('Size', [height(dataset), 9]);
output = table('ID','pb_ID', 'N', 'h', 'p', 'ndof', 'nnz', 'A_name', 'F_name');

logfile = fullfile(pwd, 'generate_meshes_runtime.log');
fid = fopen(logfile, 'a');
fprintf(fid, '\n===== JOB START %s =====\n', datestr(now));
fclose(fid);
%% Parallel initialization
nCores = str2double(getenv('NCPUS'));
if isnan(nCores)
    nCores = 1; 
end 
if isempty(gcp('nocreate'))
    parpool(nCores);
end

%% Mesh Generation
loc = 'Matrices/';
Data = CreateDataLap();
diff_A = 20; % Every tot A changes 

message = "JOB STARTS: I'm generating the data";
bot.send_message(message);

fid = fopen(logfile, 'a');
fprintf(fid, '\n===== START F [%s] =====\n', datestr(now));
fclose(fid);

output.ID = dataset.ID;
output.N  = dataset.N;
output.pb_ID = dataset.pb_ID;
output.p = dataset.p;

parfor j = 1:height(dataset)
    data = CreateDataLap(); % Data has to be created because the functions use the Data

    data.N = dataset.N(j);
    data.degree = dataset.p(j);
    ii = dataset.ID(j);
    fprintf("========= Case id: %d =========", ii);
    
    data.mu = {str2func(dataset.mu{j})}; 
    data.source = {str2func([dataset.mu{j}, '.*',dataset.f{j}])};
    data.DirBC  = {str2func(dataset.g{j})};
    name = [num2str(data.N), '_el.mat'];
    data.source

    data.meshfile = fullfile(data.FolderName, name);

    % Efficient because it reads the mesh
    [mesh, femregion, h_val] = MeshFemregionSetup(Setup, data, {data.TagElLap}, {'L'});
    h_vec(j) = h_val; % Must be like that 
    [F] = ForcingLaplacian(data, mesh.neighbor, femregion);

    PetscBinaryWrite([loc, 'F', num2str(ii) ,'.dat'], F);
    



end

delete(gcp('nocreate'));

fid = fopen(logfile, 'a');
fprintf(fid, '\n===== START A [%s] =====\n', datestr(now));
fclose(fid);

for j = 1:diff_fun:height(dataset)
    Data.N = dataset.N(j);
    Data.degree = dataset.p(j);
    ii = dataset.ID(j);
    fprintf("========= Case id: %d =========", ii);
    Data.mu = {str2func(dataset.mu{j})}; 
    Data.source = {str2func([dataset.mu{j}, '.*',dataset.f{j}])};
    Data.DirBC  = {str2func(dataset.g{j})};
    name = [num2str(Data.N), '_el.mat'];
    
    % Read the meshe name
    Data.meshfile = fullfile(Data.FolderName, name);
    
    [mesh, femregion, h_vec(j)] = MeshFemregionSetup(Setup, Data, {Data.TagElLap}, {'L'});

    [Matrices] = MatrixLaplacianST(Data, mesh.neighbor, femregion);

    PetscBinaryWrite([loc, 'A', num2str(ii) ,'.dat'], sparse(Matrices.A));

    % Create the A name file for each of the diff_fun rows
    for k = j:(diff_fun + j - 1)
        output.A_name(k) = "A" + ii + ".dat";
        output.nnz(k)    = nnz(A);
        output.ndof(k)   = size(A, 1);
    end
end

output.h = h_vec;
output.F_name = "F" + dataset.ID + ".dat";
writetable(dataset, 'dati.csv');
message = "JOB FINISHED: data generated";
bot.send_message(message);
clear bot;
