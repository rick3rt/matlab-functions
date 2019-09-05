function outPath = getPath(dataFolder, dataType, datasetName)
    % get path of EMech_waves directory on any device...

    % get path of base dir
    total = mfilename('fullpath');
    % remove dir of function to go to toplevel
    total = replace(total, '\matlab_functions', '');
    [outPath, ~, ~] = fileparts(total);

    % combine inputs to outpath
    outPath = fullfile(outPath, dataFolder, datasetName, dataType);

    % % first argument 'data' folder
    % if nargin > 0
    %     dataFolder = varargin{1};
    %     outPath = fullfile(outPath, dataFolder);
    % end
    %
    %
    % % 2nd argument can be 'datasetName' (date and identifiable name...)
    % if nargin > 1
    %     datasetName = varargin{2};
    %     outPath = fullfile(outPath, datasetName);
    % end
    %
    %
    % % 3rd argument can be dataType
    % if nargin > 2
    %     % what kind of data?
    %     dataType = varargin{3};
    %     if ~any(strcmp(dataType, {'emg', 'imaging', 'analysis'}))
    %         error(['data folder type not supported for: ' dataType]);
    %     end
    %     outPath = fullfile(outPath, dataType);
    % end

end
