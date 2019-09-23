function sout = sizes(name)
%SIZES Summary of this function goes here
%   Detailed explanation goes here

isDisp = false;
if isa(name,'char')
    evalin('caller', ['size(' name ')']);
    s = [];
else
    s = size(name);
    isDisp = true;
end

if nargout == 1 || isDisp
    sout = s;
end

end

