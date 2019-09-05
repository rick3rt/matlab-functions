function varargout = whossort(key)
    %WHOSSORT sort the output of whos, by size in Bytes

    nout = nargout;

    props = evalin('caller', 'whos');

    if ~exist('key', 'var') || isempty(key)
        key = 'bytes';
    end

    key = lower(key);
    valid_keys = {'name', 'size', 'bytes', 'class'};

    if ~strcmp(key, valid_keys)
        fprintf('%s is not a valid sort key, using ''bytes'':\n', key)
    end

    [~, sort_order] = sort([props.(key)], 'descend');
    extrapadval = 5;

    props_sort = props(sort_order);
    props_sort = rmfield(props_sort, {'global', 'sparse', 'complex', 'nesting', 'persistent'});

    T = struct2cell(props_sort).';
    Tdata = T;
    % header = fieldnames(props_sort).'; % [name, size, bytes, class]
    header = {'Name', 'Size', 'Size (MB)', 'Class'};
    sizes = T(:, 2);
    sizes_str = cellfun(@(a) join(compose('%i', a), ' by '), sizes);
    T(:, 2) = sizes_str;
    T(:, 3) = cellfun(@(a)num2str(round(a / 1e6, 2)), T(:, 3), 'UniformOutput', false);
    T = [header; T];
    max_len = max(cellfun(@length, T));
    line_div = arrayfun(@(a) repelem('=', a), max_len, 'UniformOutput', false);
    T = [T(1, :); line_div; T(2:end, :)];

    for k = 1:size(T, 2)
        T(:, k) = pad(T(:, k), max_len(k) + extrapadval);
    end

    if nout == 0
        disp_data(T)
    else
        varargout{1} = Tdata;
    end

    function disp_data(data)
        fprintf('\n\n')

        for p = 1:size(data, 1)
            fprintf('\t')

            for q = 1:size(data, 2)
                fprintf(data{p, q});
            end

            fprintf('\n');
        end

    end

end
