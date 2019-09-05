function update_abort_file(abortFileName)
    % update abort file
    fin = fopen(abortFileName, 'wt');
    fprintf(fin, 'N');
    fclose(fin);
end
