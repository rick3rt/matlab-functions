function docm(varargin)
%DOCM search matlab documentation in chrome

for k = 1:numel(varargin)
    if k > 1
        searchString = [searchString, ' ', varargin{k}];
    else
        searchString = varargin{k};
    end
end

dos(['start chrome "https://nl.mathworks.com/help/search.html?qdoc=' searchString '"']);

end