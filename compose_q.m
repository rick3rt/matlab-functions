function [q, qd, qdd] = compose_q(varargin)
%COMPOSE_Q Summary of this function goes here
%   Detailed explanation goes here

q_eval = '';
qd_eval = '';
qdd_eval = '';

for k = 1:nargin
    varName = varargin{k};
    q_eval = [q_eval varName '_i ;'];
    qd_eval = [qd_eval varName '_d_i ;'];
    qdd_eval = [qdd_eval varName '_dd_i ;'];
end

% eval in caller 
evalin('caller', ['q = [' q_eval '];']);
evalin('caller', ['qd = [' qd_eval '];']);
evalin('caller', ['qdd = [' qdd_eval '];']);

end

