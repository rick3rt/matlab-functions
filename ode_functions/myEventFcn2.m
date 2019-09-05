function [value, isterminal, direction] = myEventFcn2(t, y, startTime, maxDuration)
    %Other Events Set Here...ie:
    % value(2)=max(abs(S(1:18)))-pi/2;
    %Test to see if 'simstop' box is closed

    value(1) = min(((now - startTime) * 24 * 60 * 60) - maxDuration, 0); % in seconds
    isterminal(1) = 1;
    direction(1) = 0; % or 1. does not matter?

end
