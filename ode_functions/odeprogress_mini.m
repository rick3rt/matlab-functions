function status = odeprogress_mini(t, y, flag, Tend)

    persistent prevT;
    persistent tstart;
    persistent numIters;

    if isempty(flag)
        % What to do each Integration step
        curT = floor(t(end));

        if curT - 1 == prevT || mod(numIters, 10) == 0
            % update prev printed time
            prevT = curT;
            % update num iterations
            numIters = numIters + 1;
            % print progress
            fprintf('[%s]\t', datetime('now', 'format', 'HH:mm:ss'));
            fprintf('Sim time:\t%i/%i ms\t\t iter: %i\n', curT, Tend, numIters);
        end

        status = 0;
    else

        switch flag
            case 'init'
                % Initializing progress bar
                tstart = tic;
                prevT = 0;
                numIters = 0;
            case 'done'
                % Finishing status function
                fprintf('\n');
                telap = toc(tstart);
                fprintf('\tIntegration time:\t%.2f seconds.\n', telap);
                tstart = [];
            otherwise
                error('odeprogress_mini:UnknownError', ...
                    'Unknown error has occured');
        end

    end

end
