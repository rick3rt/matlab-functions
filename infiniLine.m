function lineHandles = infiniLine(varargin)
    % INFINILINE  Draw an infinite line on a plot
    %
    % SYNTAX
    %   infiniLine(p1, p2); % draw an infinite line through points p1 and p2
    %   infiniLine(pos, 'v'); % draw a vertical line through x-value 'pos'
    %   infiniLine(pos, 'h'); % draw a horizontal line through y-value 'pos'
    %   infiniLine(..., propName, propValue, ...); % pass property name-value pairs to line (e.g. color etc.)
    %   infiniLine(ax, ...); % draw to provided axes rather than current axes
    %
    % INPUT PARAMETERS:
    %   ax:     optional axes handle, if not provided the current axes is used
    %   p1,p2:  Two points on the infinite line to be drawn. Format is [x,y].
    %           For multiple lines add additional rows.
    %   pos:    position of vertical (x-value) or horizontal (y-value) line.
    %           Can be scalar or a vector.
    %   dir:    direction of line, 'v' for vertical, 'h' for horizontal. Can be
    %           scalar (applied to all lines) or vector of same length as pos.
    %   propName, propValue: optional line property name/value pair(s). Multiple
    %                        properties can be supplied as multiple name/value
    %                        pairs or as cell arrays of matching length. The
    %                        same properties are assigned to all lines. To
    %                        assign individual properties, either make multiple
    %                        calls to this function or take the line handles
    %                        returned and apply individual values to those.
    %
    % RETURN PARAMETERS:
    %   lineHandles: column vector of Line object handles of the added infiniLines
    %
    % DESCRIPTION
    %   infiniLine(...) draws an "infinite" line on a plot and sets up
    %   ininiLineCallBack() as the callback function to re-draw the line when
    %   the plot extents change programmatically or due to user interactive
    %   pan, zoom or auto-scale. Auto-scale is not affected by infiniLine (i.e.
    %   autoscale will only scale to objects other than inifiniLines).
    %
    %   There are two distinct ways to use this function. The first is more
    %   general where two points are defined through which a line is drawn.
    %   For convenince there is a second method, where only the position is given
    %   plus a character to indicate horizontal or vertical direction.
    %
    %   NOTE: infiniLine makes use of the undocumented 'MarkedClean' event.
    %   Undocumented features can change without prior notice. This code works
    %   in MATLAB 2016b and a few releases back, but there is no guarantee that
    %   it will work as is in the future. Use at your own risk.
    %
    % REQUIREMENTS:
    %   Needs the infiniLineCallBack() function.
    %
    % EXAMPLES:
    %   Arbitrary line syntax:
    %       plot([0 10],[10 0]);
    %       ax=gca;
    %       % draw a single vertical infinite line at x coordinate 5, make the line red,
    %       % semi-transparent and dashed
    %       infiniLine(ax,[5 0],[5 1],'Color',[1 0 0 0.5],'LineStyle','--');
    %       % draw a vertical and a horizontal infinite line at x coordinate 0.5 and
    %       % y-coordiante 0.7, make the lines red dashed
    %       infiniLine(ax,[0.5 0; 0 0.7],[0.5 1; 1 0.7],'Color',[1 0 0 0.5],'LineStyle','--');
    %       % draw four vertical lines at x=1, 2, 3 and 4 on current axes
    %       infiniLine([1 0; 2 0; 3 0; 4 0],[1 1; 2 1; 3 1; 4 1]);
    %
    %   Simplified horizontal and vertical syntax:
    %       infiniLine(3, 'v'); % draw a vertical line at x = 3
    %       infiniLine(4, 'h'); % draw a horizontal line at y = 4
    %       % Draw three infiniLines, a vertical one at x=1, and two horizontal
    %       % ones at y=2 and y=3. Color of the lines is red, semi-transparent.
    %       infiniLine([1, 2, 3], ['v', 'h', 'h'],'Color',[1, 0, 0, 0.5]);
    %
    % See also:
    %   INFINILINECALLBACK
    %   LINE
    % Version:
    %  2015-12-07 1.0.0: RZ: First, works on R215b
    %  2015-12-07 1.0.1: RZ: Now works in R215b and R215a.
    %                        infiniLine Line handles are now stored in axes.
    %  2015-12-08 2.0.0: RZ: Changed to allow arbitrary angle lines, not
    %                        backwards compatible.
    %  2016-02-01 2.1.0: RZ: Add support for log axes. If log axis is detected,
    %                        then that coordinate is stored as log10 value.
    %  2016-05-23 2.1.1: RZ: Fixed log-axis support, so it also works for
    %                        simple parameter case using 'v' and 'h'.
    %  2017-01-17 2.2.0: RZ: Fixed multiple arbitrary lines on log axis,
    %                        streamligned function documentation.
    if nargin < 2
        error('infiniLine: at least two parameters required');
    end

    % check if first parameter is an axes, if so, use it as target for ploting,
    % otherwise use current axis. Check count of remeaining parameters.
    if isa(varargin{1}, 'matlab.graphics.axis.Axes')
        ax = varargin{1};
        varargin = varargin(2:end);

        if ~mod(nargin, 2)% if even number of parameters
            error('infiniLine: when providing an axes then there must be an odd number of parameters');
        end

    else
        ax = gca;

        if mod(nargin, 2)% if odd number of parameters
            error('infiniLine: when not providing an axes then there must be an even number of parameters');
        end

    end

    % detect and parse simplified parameters for h and v lines
    if ~all(isnumeric(varargin{2}))
        pos = varargin{1};
        dir = varargin{2};

        if ~isnumeric(pos)
            error('infiniLine: position parameter must be numeric');
        end

        % if dir is cell array, convert to character array
        if iscell(dir)
            dir = char(dir);
        end

        if ~isvector(pos)
            error('infiniLine: position parameter must be scalar or vector');
        end

        if ~isvector(dir)
            error('infiniLine: direction parameter must be scalar or vector');
        end

        if ~all(dir == 'v' | dir == 'h')
            error('infiniLine: orientation parameter must be ''h'' or ''v''');
        end

        % make sure pos and dir are row vectors
        pos = pos(:)';
        dir = dir(:)';
        % check on dimensions of parameters, back-fill where needed
        if length(pos) ~= length(dir)

            if length(pos) == 1
                pos = repmat(pos, 1, length(dir));
            elseif length(dir) == 1
                dir = repmat(dir, 1, length(pos));
            else
                error('infiniLine: position and direction parameters must have same length or one of them must have length of one.');
            end

        end

        % convert simplified parameters to A, B, C defining lines as Ax+By=C
        A = double(dir == 'v')';
        B = double(~A);
        C = pos';

        % binay indices to horizontal and vertical lines
        hIdx = dir == 'h'; % binary index to horizontal lines
        vIdx = dir == 'v'; % binary index to vertical lines
        % convert position(s) to log for log axis
        if strcmp(ax.XScale, 'log')
            C(vIdx) = log10(C(vIdx));
        end

        if strcmp(ax.YScale, 'log')
            C(hIdx) = log10(C(hIdx));
        end

        % draw horizontal or vertical lines, set it to invisible for now (it may be
        % outside the current view) and hide handle, so that it does not show up in
        % legend etc.
        x = zeros(2, length(pos));
        y = zeros(2, length(pos));

        if any(hIdx)% if statement for compatibility with <=R2015a
            x(:, hIdx) = repmat(ax.XLim', 1, sum(hIdx));
            y(:, hIdx) = [pos(hIdx); pos(hIdx)];
        end

        if any(vIdx)% if statement for compatibility with <=R2015a
            x(:, vIdx) = [pos(vIdx); pos(vIdx)];
            y(:, vIdx) = repmat(ax.YLim', 1, sum(vIdx));
        end

        lineHandles = line(x, y, 'Parent', ax, 'Visible', 'off', 'HandleVisibility', 'off');
    else % arbitrary angle lines
        p1 = varargin{1};
        p2 = varargin{2};

        if ~isnumeric(p1)
            error('infiniLine: p1 parameter must be numeric');
        end

        if ~isnumeric(p2)
            error('infiniLine: p2 parameter must be numeric');
        end

        if size(p1, 2) ~= 2
            error('infiniLine: p1 parameter must be a n-by-2 matrix')
        end

        if size(p2, 2) ~= 2
            error('infiniLine: p2 parameter must be a n-by-2 matrix')
        end

        if size(p1, 1) ~= size(p2, 1)
            error('infiniLine: p1 and p2 must have same size');
        end

        % draw line, set it to invisible for now (it may be outside the current
        % view) and hide handle, so that it does not show up in legend etc.
        % draw line segment for now, let callback function extend the line to
        % limits of plot.
        lineHandles = line([p1(:, 1) p2(:, 1)]', [p1(:, 2) p2(:, 2)]', 'Parent', ax, 'Visible', 'off', 'HandleVisibility', 'off');
        % convert points to log for log axis
        if strcmp(ax.XScale, 'log')
            p1(:, 1) = log10(p1(:, 1));
            p2(:, 1) = log10(p2(:, 1));
        end

        if strcmp(ax.YScale, 'log')
            p1(:, 2) = log10(p1(:, 2));
            p2(:, 2) = log10(p2(:, 2));
        end

        % calculate A, B and C for line definition Ax+By=C
        % see: https://www.topcoder.com/community/data-science/data-science-tutorials/geometry-concepts-line-intersection-and-its-applications/
        A = p2(:, 2) - p1(:, 2); % A=y2-y1
        B = p1(:, 1) - p2(:, 1); % B = x1-x2
        C = A .* p1(:, 1) + B .* p1(:, 2); % C = A*x1+B*y1
    end

    % retrieve optional line argument/value pairs
    lineArgName = varargin(3:2:end);
    lineArgVal = varargin(4:2:end);

    if length(ax) > 1
        error('infiniLine: no support for multiple axes');
    end

    % add new hidden properties to line objects to identify them as infiniLines
    % and store some information
    for idx = 1:length(lineHandles)
        p = addprop(lineHandles(idx), 'infiniLine'); % add property to line to hold parameters
        p.Hidden = true; % hide the new property
    end

    % set the infiniLine property of lines
    for idx = 1:length(lineHandles)
        % add A, B, C to record to define line (Ax+By=C)
        lineHandles(idx).infiniLine.A = A(idx);
        lineHandles(idx).infiniLine.B = B(idx);
        lineHandles(idx).infiniLine.C = C(idx);
        % add boolean to record, indicating if this infiniLine is currently crossing through the axes
        % for now set all infiniLines to currently outside axes, let call-back set it correctly
        lineHandles(idx).infiniLine.inAxes = false;
    end

    % apply optional common line properties to lines
    for idx = 1:length(lineArgName)
        set(lineHandles, lineArgName{idx}, lineArgVal{idx});
    end

    % check if infiniLine callbacks are already installed in axis,
    %   if not, install them and add hidden property to axis object to hold
    %   property listener handles (so they become persistent) and also hold
    %   handles to all infiniLine objects
    if isempty(findprop(ax, 'infiniLine__'))
        % add hidden property
        p = addprop(ax, 'infiniLine__');
        p.Hidden = true; % make the property hidden
        % listen to XLimMode and YLimMode properties change, so we can make
        % infiniLine objects invisible before autoscale, so axis is only scaled
        % to other objects than infiniLines
        % NOTE: unfortunately this event is firing every time when the axis is
        % re-drawn and also there is no way if autoscale ibeing turned on or
        % off. So we need to temporarily turn off visibility of the infiniLines
        % for every redraw, just in case auto-scale was activated, which causes
        % flicker of the infiniLines while interactive zoom/pan
        hProp = findprop(ax, 'XLimMode');
        h1 = event.proplistener(ax, hProp, 'PreSet', @infiniLineCallBack);
        hProp = findprop(ax, 'YLimMode');
        h2 = event.proplistener(ax, hProp, 'PreSet', @infiniLineCallBack);
        % listen to MarkedClean event of axis, so we can update infiniLine
        % objects after any auto-scale, pan, zoom etc.
        % WARNING: As of M2016b MarkedClean is an undocumented event and
        % therefore can change without notice, potentially breaking
        % functionality of infiniLine
        h3 = event.listener(ax, 'MarkedClean', @infiniLineCallBack); % add listener so we can update line extent and make visible if needed
        ax.infiniLine__.propListenerHandles = {h1, h2, h3}; % store the listener handles in axes object, so they persist until axes is deleted
        ax.infiniLine__.lineHandles = matlab.graphics.primitive.Line.empty(0, 1); % create empty line object array
    end

    % store infiniLine line object handles in axes object in list of infiniLines
    ax.infiniLine__.lineHandles(end + 1:end + length(lineHandles)) = lineHandles;
    % Axes extent, so we can quickly determine if callback needs
    % to update anything next time it is called. Set to zero so first time
    % everything is calculated.
    ax.infiniLine__.axesExtent = [0 0 0 0];
    % force running callbacks once to turn on lines that are within visible
    % range
    % NOTE that Matlab will fire the XLimMode PreSet event even if there will
    % be no change to the XLimMode value
    ax.XLimMode = ax.XLimMode;
