function sizes(name)
%SIZES Summary of this function goes here
%   Detailed explanation goes here

evalin('caller', ['size(' name ')'])

end

