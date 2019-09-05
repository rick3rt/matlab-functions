function init_abort_file(abortFileName)
    % init abort file
    fin = fopen(abortFileName, 'wt');
    fprintf(fin, 'N');
    fclose(fin);
end
