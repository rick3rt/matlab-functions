function infiniLineCallBack(a, b)
    % INFINILINECALLBACK  Callback function for infiniLine, updates infiniLines
    %
    % DESCRIPTION:
    %   This function is called before and after a plot containing infiniLines
    %   is being updated. Before plot updating, all infiniLines are being
    %   hidden, so that in case auto-scale is run it won't take the infiniLines
    %   into account. After update the end points of the infiniLines are updated
    %   if needed and visibility turned on if any part of the line is inside the
    %   axis. See infiniLine.m for more information.
    %
    % Version:
    %  2015-12-07 1.0.0: RZ: First, works on R215b
    %  2015-12-07 1.0.1: RZ: Now works in R215b and R215a.
    %                        infiniLine Line handles are now stored in axes.
    %  2016-02-01 2.1.0: RZ: Add support for log axes. If log agis is detected,
    %                        then that coordinate is stored as log10 of the
    %                        used submitted value.
    %  2016-02-01 2.1.0: RZ: Add support for log axes. If log axis is detected,
    %                        then that coordinate is stored as log10 value.
    eventName = b.EventName;
    % get axes from event information
    % for event 'MarkedClean', the axes is parameter 'a'
    % for other events it is 'b.AffectedObject'
    if strcmp(eventName, 'MarkedClean')
        ax = a;
    else
        ax = b.AffectedObject;
    end

    % housekeeping: remove handles to infiniLines stored in the axis of which
    % the matching line was deleted on the plot
    ax.infiniLine__.lineHandles(~isvalid(ax.infiniLine__.lineHandles)) = [];
    % get all infiniLines
    infiniLines = ax.infiniLine__.lineHandles;
    % Just before turning on auto-scale, make lines invisible, so they do not
    % interfere with auto-scale.
    % Unfortunately Matlab repeatedly sets the XLimMode to manual every time the
    % plot is updated during interactive zoom and pan. And MATLAB sends out an
    % event every time, even though there is no change. There is currently
    % (R2016b) no way to tell appart this repeated setting of 'manual' from a
    % setting to 'automatic'. So we need to hide the infiniLines every time the
    % plot updates, and then show them again once done updating. This causes
    % the infiniLines to flicker during interactive pan and zoom.
    if strcmp(eventName, 'PreSet') && (strcmp(ax.XLimMode, 'manual') || strcmp(ax.YLimMode, 'manual'))
        set(infiniLines, 'Visible', 'off'); % hide all infiniLines when turning on autoscale so not to scale to the infiniLines
    else % set new line limits, turn line visibility on after auto-scale done or scale changed

        % check if there was any change in plot extent. If so, update line
        % extents and calculate which lines should show
        if ~all(ax.infiniLine__.axesExtent == axis(ax))
            % pre-allocate space
            A = zeros(length(infiniLines), 1);
            B = A;
            C = A;
            % copy line parameters from infiniLines (defining lines as Ax+By=C)
            for idx = 1:length(infiniLines)
                A(idx) = infiniLines(idx).infiniLine.A;
                B(idx) = infiniLines(idx).infiniLine.B;
                C(idx) = infiniLines(idx).infiniLine.C;
            end

            % get current plot extent
            ext = axis;

            % deal with log axes
            if strcmp(ax.XScale, 'log')
                ext(1:2) = log10(ext(1:2));
            end

            if strcmp(ax.YScale, 'log')
                ext(3:4) = log10(ext(3:4));
            end

            % set A, B, C for axes border lines (defining lines as Ax+By=C)
            % line 1: left
            % line 2: right
            % line 3: bottom
            % line 4: top
            borderA = [1 1 0 0];
            borderB = [0 0 1 1];
            borderC = ext;

            % for each line now find the intercept points with the four border
            % lines
            for idx = 1:length(infiniLines)
                % calculate x, y coordinates of intersect points
                % if det==0 then there is no intersect (parallel)
                det = A(idx) * borderB - borderA * B(idx);
                x = (borderB * C(idx) - B(idx) * borderC) ./ det;
                y = (borderC * A(idx) - C(idx) * borderA) ./ det;

                % eliminate -Inf values in x (we sort later by x), replace with +Inf
                x(isinf(x) | isnan(x)) = inf;

                % sort intersects by ascending x coordinate
                [x, I] = sort(x);
                y = y(I);

                % intersect with bounding box are first two points if parallel,
                % middle two points if not parallel
                ispar = isinf(x(4));
                x = x([1 2]+~ispar);
                y = y([1 2]+~ispar);

                % calculate center point of line segments
                cpx = mean(x, 2);
                cpy = mean(y, 2);

                % check if center point is within bounding box, if so, turn
                % line on and set its endpoints to intersect points with bounding
                % box
                if cpx > ext(1) && cpx < ext(2) && cpy > ext(3) && cpy < ext(4)
                    infiniLines(idx).infiniLine.inAxes = true;
                    % set infiniLine end points, deal with log axes
                    if strcmp(ax.XScale, 'log')
                        infiniLines(idx).XData = 10.^x;
                    else
                        infiniLines(idx).XData = x;
                    end

                    if strcmp(ax.YScale, 'log')
                        infiniLines(idx).YData = 10.^y;
                    else
                        infiniLines(idx).YData = y;
                    end

                else
                    infiniLines(idx).infiniLine.inAxes = false;
                end

            end

            % update stored axes extent, so we can quickly determine if callback needs
            % to update anything next time it is called
            ax.infiniLine__.axesExtent = axis(ax);
        end

        % turn on visibility of lines that are within axes
        for idx = 1:length(infiniLines)

            if infiniLines(idx).infiniLine.inAxes
                infiniLines(idx).Visible = 'on';
            end

        end

    end
