function cdc(varargin)
% CDC function to quickly change directories
%   Choose of one of the following:
%   -   prog
%   -   study
%   -   home
%   -   thesis

%% location of the different folders
data = {
    'home'  "C:\Users\rickw\OneDrive\Documenten\MATLAB";
    'prog'  "C:\Users\rickw\OneDrive\Programming\Matlab";
    'study' "C:\Users\rickw\OneDrive\Studie\BMD_Master";
    'ufus'  "C:\Users\rickw\OneDrive\Studie\BMD_Master\Thesis\Verasonic";
    'thesis' "C:\Users\rickw\OneDrive\Studie\BMD_Master\Thesis";
    'sipe'  "C:\Users\rickw\OneDrive\Studie\BMD_Master\ME41065 - System Identification and Parameter Estimation";
    'mbdb'  "C:\Users\rickw\OneDrive\Studie\BMD_Master\ME41055 - Multibody Dynamics B";
    'so'    "C:\Users\rickw\OneDrive\Programming\Matlab\SO";
    'imph'  "C:\Users\rickw\OneDrive\Studie\BMD_Master\Internship_ImPhys\Verasonic";
};


%% handle input arguments

% number of input arguments
n = nargin;
nfolders = length(data);

% if no argument, then show help (possible options)
if isempty(varargin)
    varargin{1} = 'help';
end

% select what to do (order matters)
if strcmp(varargin{1}, 'help')
    printData();
elseif n == 1 && strcmp(varargin{1}, '?')
    % list subfolders
    obtainSubFolders(true);
elseif n==1 && isnan(str2double(varargin{1}))
    % first agument is short foldername
    folderName = varargin{1};
    changeDir(folderName);
elseif n==1 && ~isnan(str2double(varargin{1}))
    % first argument is number
    fnum = str2double(varargin{1});
    folderList = obtainSubFolders(false);
    cd(folderList(fnum).name);
elseif n==2 && isnan(str2double(varargin{1})) && strcmp(varargin{2},'?')
    % first argument is short foldername, second question mark
    changeDir(varargin{1});
    obtainSubFolders(true);
elseif n==2 && isnan(str2double(varargin{1})) && ~isnan(str2double(varargin{2}))
    % first argument is short foldername, second number
    changeDir(varargin{1});
    fnum = str2double(varargin{2});
    folderList = obtainSubFolders(false);
    cd(folderList(fnum).name);
end
    






%% functions (same scope as main function

function folderList = obtainSubFolders(display_screen)
    % Obtain subfolders
    % Get a list of all files and folders in this folder.
    files = dir;
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);
    subFolders(1:2) = [];
    folderList = subFolders;
    
    % Print folder names to command window.
    if display_screen
        fprintf('Subfolders to choose from:\n')
        for k = 1 : length(subFolders)
            fprintf('\t% 3.0f\t\t%s\n', k, subFolders(k).name);
        end
    end
end


function changeDir(folderName)
    % check for folder hit
    for ii=1:nfolders
        % check for hit
        % USE strcmp or contains... contains is less strict
        if contains(data{ii,1}, folderName)
            cd(data{ii,2});
            break;
        end
        
        % no hit, show error
        if ii == nfolders
            error('No match found!');
        end
    end
end


function printData()
    % print data to choose from
    fprintf('Folder shortcuts available:\n')
    for ii=1:nfolders
        fprintf('\t%s\t\t%s\n', data{ii,1},data{ii,2});
    end
    fprintf('\n')
end


end