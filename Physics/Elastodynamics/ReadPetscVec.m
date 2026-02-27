function x = ReadPetscVec(filename)
    %READPETSCVEC Reads a PETSc binary vector written in PETSc format
    %   x = ReadPetscVec(filename)

    fid = fopen(filename, 'r', 'ieee-le');
    if fid < 0
        error('Cannot open file %s', filename);
    end

    % --- Read header ---
    header = fread(fid, 2, 'int32');
    magic  = swapbytes(header(1));
    n      = swapbytes(header(2));

    if magic ~= 1211214
        fclose(fid);
        error('Invalid PETSc Vec file. Magic number mismatch: expected 1211214, got %d', magic);
    end

    % --- Read vector ---
    x = fread(fid, n, 'double');
    x = swapbytes(x);

    fclose(fid);
end
