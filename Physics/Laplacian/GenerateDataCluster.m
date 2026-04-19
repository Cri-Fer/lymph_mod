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
dataset     = readtable('InputData.csv');
h_vec       = zeros(height(dataset),1);
ndof_vec    = zeros(height(dataset),1);
nnz_vec     = zeros(height(dataset),1);
A_name      = strings(height(dataset), 1);
F_name      = strings(height(dataset), 1);

% We save id; pb_id; N, h, p, ndof, nnz, A_name, F_name
sz = [height(dataset), 9];
varTypes = {'int32', 'int8', 'int32', 'double', 'int8', 'int32', 'int32', 'string', 'string'};
varNames = {'ID', 'pb_ID', 'N', 'h', 'p', 'ndof', 'nnz', 'A_name', 'F_name'};

output = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames);

%% Matrix Generation
loc = 'Matrices/';
Data = CreateDataLap();
jump= 11; % Every tot A changes 

message = "JOB STARTS: I'm generating the data";
bot.send_message(message);

%% Parallel initialization
nCores = str2double(getenv('NCPUS'));
if isnan(nCores)
    nCores = 1; 
end 
if isempty(gcp('nocreate'))
    parpool(nCores);
end
% 1. Estrazione variabili per evitare il Broadcasting
N_vec  = dataset.N;
p_vec  = dataset.p;
ID_vec = dataset.ID;
mu_vec = dataset.mu;
f_vec  = dataset.f;
g_vec  = dataset.g;
Folder = Data.FolderName; % Assumendo che sia costante

message = "START A";
bot.send_message(message);

parfor j = 1:height(dataset)
    Data = CreateDataLap();
    Data.N = N_vec(j);
    Data.degree = p_vec(j);
    ii = ID_vec(j);
    fprintf("========= Case id: %d =========\n", ii);
    Data.mu = {str2func(mu_vec{j})}; 
    Data.source = {str2func([mu_vec{j}, '.*',f_vec{j}])};
    Data.DirBC  = {str2func(g_vec{j})};
    name = [num2str(Data.N), '_el.mat'];
    
    % Read the meshe name
    Data.meshfile = fullfile(Data.FolderName, name);
    
    [mesh, femregion, h_vec(j)] = MeshFemregionSetup(Setup, Data, {Data.TagElLap}, {'L'});

    [Matrices] = MatrixLaplacianST(Data, mesh.neighbor, femregion);

    PetscBinaryWrite([loc, 'A', num2str(ii) ,'.dat'], sparse(Matrices.A));

    % Create the A name file for each of the diff_fun rows
    A_name(j) = "A" + num2str(ii) + ".dat";
    nnz_vec(j)    = nnz(Matrices.A);
    ndof_vec(j)   = size(Matrices.A, 1);

    java.lang.System.gc();
end

delete(gcp('nocreate'));

message = "START F";
bot.send_message(message);


for j = 1:jump:height(dataset)
    data = CreateDataLap(); % Data has to be created because the functions use the Data

    data.N = dataset.N(j);
    data.degree = dataset.p(j);
    ii = dataset.ID(j);
    fprintf("========= Case id: %d =========\n", ii);

    data.mu = {str2func(dataset.mu{j})}; 
    data.source = {str2func([dataset.mu{j}, '.*',dataset.f{j}])};
    data.DirBC  = {str2func(dataset.g{j})};
    name = [num2str(data.N), '_el.mat'];

    data.meshfile = fullfile(data.FolderName, name);

    % Efficient because it reads the mesh
    [mesh, femregion, h_val] = MeshFemregionSetup(Setup, data, {data.TagElLap}, {'L'});
    h_vec(j) = h_val; % Must be like that 
    [F] = ForcingLaplacian(data, mesh.neighbor, femregion);

    PetscBinaryWrite([loc, 'F', num2str(ii) ,'.dat'], F);

    % Create the F name file for each of the diff_fun rows
    for k = j:(jump + j - 1)
        F_name(k) = "F" + num2str(ii) + ".dat";
    end
    
end



output.ID = dataset.ID;
output.N  = dataset.N;
output.pb_ID = dataset.pb_ID;
output.p = dataset.p;
output.h = h_vec;
output.ndof = ndof_vec;
output.nnz = nnz_vec;
output.A_name = A_name;
output.F_name = F_name;

writetable(output, 'output.csv');
message = "JOB FINISHED: data generated";
bot.send_message(message);
clear bot;
