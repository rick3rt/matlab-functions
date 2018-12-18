function vv = struct2syms(s)


fnames = fieldnames(s);
n = length(fnames);
v = sym(zeros(n,1));

for ii=1:n
    v(ii) = s.(fnames{ii});
end

vv = v;
    