function [value, isterminal, direction] = myEventFcn3(t, y, maxTimeOut, abortFile, tspan)

    % determine number of iterations per time bin
    persistent iterations_per_bin

    if isempty(iterations_per_bin)
        iterations_per_bin = zeros(size(tspan));
    end

    bin_num = find(t <= tspan, 1, 'first');
    iterations_per_bin(bin_num) = iterations_per_bin(bin_num) + 1;

    if bin_num > numel(tspan) - 1
        assignin('base', 'iterations_per_bin', iterations_per_bin)
    end

    % make dependent on last update time abort/log file
    f = dir(abortFile);
    lastTime = f.datenum;

    % determine if time out reached.
    value(1) = min(((now - lastTime) * 24 * 60 * 60) - maxTimeOut, 0); % in seconds
    isterminal(1) = 1;
    direction(1) = 0; % or 1. does not matter

    if value(1) == 0
        fprintf('SIMULATION TIME OUT\n')
    end

end
