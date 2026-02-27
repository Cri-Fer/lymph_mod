%> @file  MainEla.m
%> @author Ilario Mazzieri, Mattia Corti, Stefano Bonetti
%> @date 23 July 2024
%> @brief Solution of the elastodynamics equation with PolydG
%>
%==========================================================================
%> @section classMainEla Class description
%==========================================================================
%> @brief            Solution of the elastodynamics eq. with PolydG
%
%> @param Data       Struct with problem's data
%> @param Setup      Simulation setup
%
%> @retval Error     Struct with computed errors 
%>
%==========================================================================

function [Error, Matrices, U_h] = MainEla_nosol_staticcase(Data,Setup)

%% Mesh

[mesh, femregion, Data.h] = MeshFemregionSetup(Setup, Data, {Data.TagElEla}, {'E'});

%%  Matrix Assembly

fprintf('\nMatrices computation ... \n');
tic
switch Data.quadrature
    case "QF"
        [Matrices] = MatElaQF(Data, mesh.neighbor, femregion);
    case "ST"
        [Matrices] = MatElaST(Data, mesh.neighbor, femregion);
end
toc
fprintf('Done \n')
fprintf('\n------------------------------------------------------------------\n')




%% Assembly of the ODE system C x

fprintf('\nAssembly ODE system matrices ... \n');
C = Matrices.Ela.A_E + Matrices.Ela.Ddis + Matrices.Ela.Rdis;
[F, ~] = ForEla(Data, mesh.neighbor, femregion, 0);
fprintf('\nDone\n')
fprintf('\n------------------------------------------------------------------\n')

%%EXTRMAT
dest = "\\wsl.localhost\ubuntu\home\calu\PETSc_Test\Files";
WritePetscMat(dest + 'matrix_A.dat', C);
WritePetscMat(dest + 'matrix_b.dat', F);

end