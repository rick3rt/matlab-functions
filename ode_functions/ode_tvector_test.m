clear
close all

tspan = [0 2000];
tstep = 1;

odeOpts = odeset('outputFcn', @testf, 'stats', 'on');

fprintf('\n\n')

tspan_fix = tspan(1):tstep:tspan(2);
[t_fix,y_fix] = ode15s(@vdp1000, tspan_fix, [2 0], odeOpts);
tvector_fix = tvector;

fprintf('\n\n')

tspan_var = tspan;
[t_var,y_var] = ode15s(@vdp1000, tspan_var, [2 0], odeOpts);
tvector_var = tvector;

fprintf('\n\n')

%%
y_var_fix = interp1(t_var, y_var, t_fix);

err = sum((y_var_fix - y_fix).^2)


%%
figure(1); clf;
subplot(211); hold on;
    plot(t_fix,y_fix(:,1),'-o')
    plot(tvector_fix, zeros(size(tvector_fix)),'o')
subplot(212); hold on;
    plot(t_var,y_var(:,1),'-o')
    plot(tvector_var, zeros(size(tvector_var)),'o')

%%

whos *var*
whos *fix*


%%
function status = testf(t,y,flag)
    
    persistent tvector;

    if isempty(flag)
        % What to do each Integration step
        tvector(end+1) = t(end);
        status = 0;
    else

        switch flag
            case 'init' 
                % Initializing progress bar
                tvector = t(end);
                status = 0;
            case 'done' 
                % Finishing status function
                assignin('base', 'tvector', tvector);
            otherwise
                error('testf:UnknownError', 'Unknown error has occured');
        end

    end

end
