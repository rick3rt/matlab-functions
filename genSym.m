function [var_i, var_d_i, var_dd_i] = genSym(symName, symSize, indexLetter)
%GENSYM Creates something like below, and assigns in caller workspace.
%   Ltendon_i   =   sym('Ltendon_', [2 1], 'real');
%   Ltendond_i  =   sym('Ltendond_', [2 1], 'real');
%   Ltendondd_i =   sym('Ltendondd_', [2 1], 'real');

% if not provided, scalar
if ~exist('symSize', 'var')
    symSize = 1;
end

if ~exist('indexLetter', 'var')
    indexLetter = 'i';
end

% if only one size, this is the first dimension.
if numel(symSize) == 1
    symSize = [symSize 1];
end

% generate symbolics
var_i = sym([symName '_'], symSize, 'real');
var_d_i = sym([symName 'd_'], symSize, 'real');
var_dd_i = sym([symName 'dd_'], symSize, 'real');

if nargout ~= 3
    % assign in caller
    assignin('caller', [symName '_' indexLetter], var_i);
    assignin('caller', [symName 'd_' indexLetter], var_d_i);
    assignin('caller', [symName 'dd_' indexLetter], var_dd_i);
end

% eof
end

