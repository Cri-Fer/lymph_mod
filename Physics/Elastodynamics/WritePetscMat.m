function WritePetscMat(filename, A)
    if ~issparse(A)
        A = sparse(A);
    end

    [m,n] = size(A);
    [i,j,s] = find(A');  % PETSc vuole colonne come righe
    n_nz = full(sum(A' ~= 0));
    nz = sum(n_nz);

    fid = fopen(filename, 'w', 'ieee-le');

    % --- Header in little endian "vero"
    header = int32([1211216, m, n, nz]);
    header_le = swapbytes(header);
    fwrite(fid, header_le, 'int32');

    % --- Dati (tutti little endian espliciti)
    fwrite(fid, swapbytes(int32(n_nz)), 'int32');
    fwrite(fid, swapbytes(int32(i-1)), 'int32');
    fwrite(fid, swapbytes(double(s)), 'double');

    fclose(fid);
end
