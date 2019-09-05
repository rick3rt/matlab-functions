function structOut = arrayifystruct(structIn)
    %ARRAYIFYSTRUCT takes an struct array where each field in the struct has only
    %   one element, and makes it into a struct that contains vectors for each field
    %
    %   Example:
    %       A = repmat(struct('a', 1, 'b', 2), 10, 1)
    %           A =
    %             10×1 struct array with fields:
    %             a
    %             b
    %       B = arrayifystruct(A)
    %           B =

    % get stuff from struct array
    fnames = fieldnames(structIn);
    s = size(structIn);
    placeholder = NaN(s);
    cpl = repmat({placeholder}, size(fnames)); % cell with arrays of NaNs

    % init new struct (all NaNs)
    structOut = cell2struct(cpl, fnames, 1);

    % put data in thing
    data = struct2cell(structIn);

    for k = 1:numel(fnames)

        try
            structOut.(fnames{k}) = reshape([data{k, :}], s);
        catch ME
            % fnames{k}
            % data{k,:}
            % ME
            switch ME.identifier
                case 'curvefit:fittype:horzcat:catNotPermitted'
                    error('Do not use function fits with vectorized approach');
                case 'MATLAB:getReshapeDims:notSameNumel'
                    structOut.(fnames{k}) = [data{k,:}];
                otherwise
                    rethrow(ME)
            end

        end

    end

end
