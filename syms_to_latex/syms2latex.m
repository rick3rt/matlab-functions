function syms2latex(varargin)

n = length(varargin);

if exist('matlab_latex_strings.txt', 'file')
    !del matlab_latex_strings.txt
end

diary matlab_latex_strings.txt

disp(' ')
disp('texts = [')

for ii = 1:n
    symstring = varargin{ii};
    disp([' r"' latex(symstring) '",'])
end

disp(']')

diary off
!py C:\Users\rickw\OneDrive\Programming\Matlab\syms_to_latex\replace_symbols.py

end