function status = outputFcnWrapper(t,y,flag)
    status = odeplot_rw(t,y,flag);
    odetpbar(t,y,flag);
end