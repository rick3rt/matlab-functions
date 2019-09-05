function loadCellFast(matFileName)
%SAVECELLFAST load mat files that contain reformatted cell arrays
%   that were saved using the saveCellFast function.
%
%   matFileName     The name of the mat file to load
% 
% Inspired by the 'savefast' function from the Matlab Exchange
%  created by  Timothy E. Holy
%

% load the matfile in function workspace
data = load(matFileName);

varNames = fieldnames(data);
outCell = {};

for k = 1:numel(varNames)
    varSplit = strsplit(varNames{k},'_');
    ogFileName = varSplit{1};
    if strcmp(varSplit{4}, 'cell')
        n = str2num(varSplit{2});
        m = str2num(varSplit{3});
        outCell{n,m} = data.(varNames{k});
    end
end

% assign in base workspace (or caller)
assignin('caller', ogFileName, outCell)