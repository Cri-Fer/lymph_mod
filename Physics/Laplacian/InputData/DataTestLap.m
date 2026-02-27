%% Poisson problem in [0,1]^2 with Dirichlet conditions

Data.name = 'ConvTestLapDir';

Data.TagElLap = 1;         % Element tag
Data.TagBcLap = [2 3 4 5]; % Boundary tag
Data.LabBcLap = 'DDDD';    % Dirichlet/Neumann/Abso

%% Geometrical properties 
Data.domain       = [0 1 0 1]; % domain bounds for a new mesh
Data.N            = 1;     % number of elements for a new mesh
Data.MeshFromFile = true;      % read mesh from file
Data.FolderName   = 'InputMesh';
Data.VTKMeshFileName = 'Mesh.vtk';
Data.meshfileseq  = 'Quad_19600_el.mat'; %filename for mesh

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
Data.source = {@(x,y) 8*pi^2 * sin(2*pi*x).* cos(2*pi*y)};


% Boundary Conditions
Data.DirBC    = {@(x,y) (x.^2+y).^1.5};

% Exact Solution (if any)
Data.u_ex     =  {@(x,y) sin(2*pi*x).* cos(2*pi*y)};

% Gradient of the Exact Solution
Data.gradu_ex =  {@(x,y)   2*pi*cos(2*pi*x).*cos(2*pi*y); ...
                  @(x,y)  -2*pi*sin(2*pi*x).*sin(2*pi*y)};

%% Do you want to solve it?
Data.solve = false;

