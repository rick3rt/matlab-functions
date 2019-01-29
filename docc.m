function docc(varargin)
%DOCC search matlab information in chrome via google search

for k = 1:numel(varargin)
    if k > 1
        searchString = [searchString, ' ', varargin{k}];
    else
        searchString = varargin{k};
    end
end

dos(['start chrome "https://www.google.com/search?q=matlab ' searchString '"']);

end