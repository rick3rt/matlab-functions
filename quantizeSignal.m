function out = quantizeSignal(in, step)
% QUANTIZESIGNAL quantizes the input signal with specified level step
% 
%   out = QUANTIZESIGNAL(in, step)
% 
% rw - 21Jun2019

out = NaN(size(in));

maxv = max(abs(in), [], 'all'); % along all dimensions
% minv = min(in, [], 'all'); %

lvls1 = 0:step:maxv+step;
% lvls2 = -step:-step:minv-step;
% lvls = flip([lvls2 lvls1]);

for lvl = lvls1
    out(abs(in) >= lvl) = lvl*sign(in(abs(in) >= lvl));
end

end