function WritePetscVec(filename, x)
    x = x(:);                % colonna
    n = numel(x);
    fid = fopen(filename, 'w', 'ieee-le');

    header = int32([1211214, n]);
    fwrite(fid, swapbytes(header), 'int32');
    fwrite(fid, swapbytes(double(x)), 'double');

    fclose(fid);
end