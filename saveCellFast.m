function saveCellFast(matFileName, cellArrayName)
%SAVECELLFAST save cell arrays containing large multidimensional matrices
%   fast. Cells can be 2 dimensional. 
%
%   matFileName     The name of the resulting mat file
% 
%   cellArrayName   The name of the cell array to save fast.
%
% Based on the 'savefast' function from the Matlab Exchange
%  created by  Timothy E. Holy
%

% get the cell array in the function workspace
cellArray = evalin('caller', cellArrayName); % 'base' or 'caller'?

% create new variables based on the cellArrayName
[n,m] = size(cellArray);

% if only one cell in cellArray, then keep original name
if 0 %n == 1 && m == 1
    varNamesToSave{1} = cellArrayName;
% otherwise, make array
else
    varNamesToSave = {};
    for k = 1:n
        for l = 1:m
            % store names to save
            varNamesToSave{end+1} = [cellArrayName '_' num2str(k) '_' num2str(l) '_cell'];
            % eval expression
            evalc([varNamesToSave{end} ' = cellArray{' num2str(k) ',' num2str(l) '}']);
        end
    end
end


%% save the created variables (credits to Timothy E. Holy)

% Extract the variable values
vars = cell(size(varNamesToSave));
for i = 1:numel(varNamesToSave)
    vars{i} = eval(varNamesToSave{i});
end

% Separate numeric arrays from the rest
isnum = cellfun(@(x) isa(x, 'numeric'), vars);

% Append .mat if necessary
filename = matFileName;
[filepath, filebase, ext] = fileparts(filename);
if isempty(ext)
    filename = fullfile(filepath, [filebase '.mat']);
end

create_dummy = false;
if all(isnum)
    % Save a dummy variable, just to create the file
    dummy = 0;
    save(filename, '-v7.3', 'dummy');
    create_dummy = true;
else
    s = struct;
    for i = 1:numel(isnum)
        if ~isnum(i)
            s.(varNamesToSave{i}) = vars{i};
        end
    end
    save(filename, '-v7.3', '-struct', 's');
end

% Delete the dummy, if necessary, just in case the user supplied a
% variable called dummy
if create_dummy
    fid = H5F.open(filename,'H5F_ACC_RDWR','H5P_DEFAULT');
    H5L.delete(fid,'dummy','H5P_DEFAULT');
    H5F.close(fid);
end

% Save all numeric variables
for i = 1:numel(isnum)
    if ~isnum(i)
        continue
    end
    varname = ['/' varNamesToSave{i}];
    h5create(filename, varname, size(vars{i}), 'DataType', class(vars{i}));
    h5write(filename, varname, vars{i});
end


end
