function Data = CreateDataLap()
%CREATEDATALAP Summary of this function goes here
%   Detailed explanation goes here
Data.TagElLap = 1;         % Element tag
Data.TagBcLap = [2 3 4 5]; % Boundary tag
Data.LabBcLap = 'DDDD';    % Dirichlet/Neumann/Abso

%% Geometrical properties 
Data.domain       = [0 1 0 1]; % domain bounds for a new mesh
Data.N            = 1;     % number of elements for a new mesh
Data.MeshFromFile = true;      % read mesh from file
Data.FolderName   = 'MESH';
Data.VTKMeshFileName = 'Mesh.vtk';
Data.meshfileseq  = ''; %filename for mesh

%% Space discretization
Data.degree  = 3;        % Polynomial degree
Data.penalty_coeff = 10; % Penalty coefficient

%% Quadrature settings
Data.quadrature = "ST";       % Quadrature type: ST/QF

%% Visualization settings
Data.PlotExact         = false;
Data.PlotGridSol       = false;
Data.NPtsVisualization = 5;

%% Material properties 
Data.mu       = {@(x,y) 2};

% Forcing Term
Data.source = {@(x,y) 0};


% Boundary Conditions
Data.DirBC    = {@(x,y) 0};

end