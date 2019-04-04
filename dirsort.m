function dirsort(dirName)

if ~exist('dirName','var')
    dirName = '.';
end

d = dir(dirName);

% remove . and ..
d(1:2) = [];

fileInfo = {};

for k=1:numel(d)
    fileNames(k,1) = string(d(k).name);
    fileDates(k,1) = datetime(d(k).date,'InputFormat','dd-MMM-yyyy HH:mm:ss');
    fileSize(k,1) = d(k).bytes;
end

Name = fileNames;
Date = fileDates;
SizeKB = fileSize/1000;
SizeMB = SizeKB/1000;

T = table(Name,Date,SizeKB, SizeMB);
T = sortrows(T, 'Date', 'descend');
disp(T);