function saveFigures( figure_cell, width, height, renderer)
%SAVEFIGURES Save figures stored in a cell
%   SAVEFIGURES(FIGURECELL), saves the figures of which the handles are
%   stored in the FIGURECELL object (default width x height: 26 x 22). 
% 
%   SAVEFIGURES(FIGURECELL, WIDTH, HEIGHT), saves the figures with the
%   specified WIDTH and HEIGHT in centimeters.


% Check if width and height variables are defined, else set default values
if ~exist('width','var')
    width = 26;
end

if ~exist('height','var')
    height = 22;
end

if ~exist('renderer', 'var')
    renderer = '-dpdf';
end

% Check if multiple or single figure is inputed:
if numel(figure_cell) > 1
    multiple = true;
else
    multiple = false;
end


% loop over the figure cell to save the figures
for f = 1:numel(figure_cell)

    if multiple
        fig = figure_cell{f};
    else
        fig = figure_cell;
    end

    if isvalid(fig)
        % % Resize the figure
        % set(fig, 'Units', figUnits);
        % pos = get(fig, 'Position');
        % pos = [pos(1), pos(4)+figSize(2), pos(3)+figSize(1), pos(4)];
        % set(fig, 'Position', pos);

        % Change size
        % set(gcf,'units','centimeters')
        set(fig, 'paperunits', 'centimeters')
        set(fig, 'PaperPositionMode', 'manual');
        set(fig, 'papersize', [width,height])
        set(fig, 'paperposition', [0,0,width,height])
        set(fig, 'renderer', 'painters');

        % set filename
        filename = fig.Name;
        if isempty(filename)
            filename = ['figure_' num2str(fig.Number)];
        end
        

        % Output the figure
        filename = strrep(filename, ' ', '_');
        if strcmp(renderer, '-dpdf')
            print( fig, '-dpdf', filename , '-r600');
        elseif strcmp(renderer,'-dpng')
            print( fig, '-dpng', filename ,'-r600');
        end
        disp([filename ' saved'])
    end
    
    
end

disp('All requested figures saved.');
disp(' ');
    
end






