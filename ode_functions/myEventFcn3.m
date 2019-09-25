function [value, isterminal, direction] = myEventFcn3(t, y, maxTimeOut, abortFile)

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
