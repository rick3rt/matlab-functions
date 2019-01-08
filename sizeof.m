function varargout = sizeof(variableName)
%SIZEOF Obtain the number of bytes for a variable name (input variable name
%   as 'char' array).

    if ~isa(variableName, 'char')
        error('Input the variable name in ''quotes''.')
    end
    
    nout = nargout;

    props = evalin('base', ['whos(''' variableName ''')']);
    
    numBytes = props.bytes;
    
    if nout == 0
        fprintf('\tNumber of Bytes:\t\t%i\n\tNumber of MegaBytes:\t%.2f\n\n', ...
            numBytes, numBytes*1e-6);
    else
        varargout{1} = numBytes;
    end
    
end

