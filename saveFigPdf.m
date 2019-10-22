function saveFigPdf(fig, filename, figsize, resolution, printjpg)
% function saveFigPdf(fig, filename, figsize, resolution)

    if ~exist('figsize', 'var') || isempty(figsize)
        figsize = [8, 5];
    end

    if ~exist('resolution', 'var') || isempty(resolution)
        resolution = '-r300';
    end

    if ~exist('printjpg', 'var') || isempty(printjpg)
        printjpg = false;
    end

    % set paper settings
    fig.PaperUnits = 'centimeters';
    fig.PaperPositionMode = 'manual';
    fig.PaperSize = figsize;
    fig.PaperPosition = [0, 0, figsize(1), figsize(2)];
    fig.Renderer = 'painters';

    % print to pdf
    print(fig, '-dpdf', filename, resolution);
    if printjpg
        print(fig, '-djpeg', filename);
    end

end
