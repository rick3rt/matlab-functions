function set_fontsize_proportional(handle, factor)
    
handles_txt = findall(handle, '-property', 'fontsize');
cellfun(@(c1,c2) set(c1, 'fontsize', c2),num2cell(handles_txt), num2cell(cell2mat(get(handles_txt, 'fontsize'))*factor));

end