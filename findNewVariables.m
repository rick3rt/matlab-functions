function names2 = findNewVariables(state)

persistent names1

if state == 1
    % store variables currently in caller workspace
    names1 = evalin('caller', 'who');
    names2 = [];

elseif state == 2
    % which variables are in the caller workspace in the second call
    names2 = evalin('caller', 'who');

    % find which variables are new, and filter previously stored
    ids = ismember(names2,names1) ~= 1;
    names2(~ids) = [];
    names2(strcmp(names2, 'names1')) = [];
    names2(strcmp(names2, 'names2')) = [];
    names2(strcmp(names2, 'ans')) = [];
end