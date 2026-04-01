function [Matrices, F, Data] = DataGenerator(Data,Setup)
%> @file  MainLaplacian.m
%> @author The Lymph Team
%> @date 26 July 2024
%> @brief Solution of the Poisson problem with PolydG
%>
%==========================================================================
%> @section classMainLaplacian Class description
%==========================================================================
%> @brief            Solution of the Poisson problem with PolydG
%
%> @param Data       Struct with problem's data
%> @param Setup      Simulation's setup
%>
%> @retval Error     Struct for convergence test
%>
%==========================================================================
%% Mesh setup
[mesh, femregion, Data.h] = MeshFemregionSetup(Setup, Data, {Data.TagElLap}, {'L'});

%% Matrix Assembly
switch Data.quadrature
    case "QF"
        [Matrices] = MatrixLaplacianQF(Data, mesh.neighbor, femregion);
    case "ST"
        [Matrices] = MatrixLaplacianST(Data, mesh.neighbor, femregion);
end

%% Right-hand side assembly
[F] = ForcingLaplacian(Data, mesh.neighbor, femregion);

end


