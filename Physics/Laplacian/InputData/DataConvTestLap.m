%% Poisson problem in [0,1]^2 with Dirichlet conditions

Data.name = 'Lap';

Data.TagElLap = 1;         % Element tag
Data.TagBcLap = [2 3 4 5]; % Boundary tag
Data.LabBcLap = 'DDDD';    % Dirichlet/Neumann/Abso

%% Geometrical properties 
Data.domain       = [0 1 0 1]; % domain bounds for a new mesh
Data.N            = {100, 200, 400, 800};        % number of elements for a new mesh
Data.MeshFromFile = false;     % read mesh from file
Data.FolderName   = 'InputMesh';
Data.VTKMeshFileName = 'Mesh.vtk';
Data.meshfileseq  = {"Lap_100_el.mat","Lap_200_el.mat", ... 
                     "Lap_400_el.mat", "Lap_800_el.mat"};  %filename for mesh 

%% Space discretization
Data.degree  = 4;   % Polynomial degree
Data.penalty_coeff = 10; % Penalty coefficient

%% Quadrature settings
Data.quadrature = "ST";       % Quadrature type: ST/QF

%% Visualization settings
Data.PlotExact         = true;
Data.PlotGridSol       = true;
Data.NPtsVisualization = 3;

%% Material properties 
Data.mu       = {@(x,y) (x+y.^2+1)};

% Forcing Term
Data.source = {@(x,y) - (3*(y.^2 + x + 1))./(4*(x.^2 + y).^(1/2)) ...
                      - 3*(x.^2 + y).^(1/2).*(y.^2 + x + 1) ...
                      - 3*x.*(x.^2 + y).^(1/2) ...
                      - 3*y.*(x.^2 + y).^(1/2) ...
                      - (3*x.^2.*(y.^2 + x + 1))./(x.^2 + y).^(1/2)};


% Boundary Conditions
Data.DirBC    = {@(x,y) (x.^2+y).^1.5};

% Exact Solution (if any)
Data.u_ex     =  {@(x,y) (x.^2+y).^1.5};

% Gradient of the Exact Solution
Data.gradu_ex =  {@(x,y)   3*x.*(x.^2 + y).^(1/2); ...
                  @(x,y)  (3*(x.^2 + y).^(1/2))/2};
