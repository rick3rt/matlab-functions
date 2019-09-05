function status = odeprogress_mini_abort(t, y, flag, Tend, abortFileName)

    persistent prevT;
    persistent tstart;
    persistent numIters;

    STOPCONDITION = false;

    if isempty(flag)
        % What to do each Integration step
        curT = floor(t(end));
        % update num iterations/outputfcn calls
        numIters = numIters + 1;
        % pause(0.3) % DEBUG
        if curT - 1 == prevT || mod(numIters, 1) == 100
            % update prev printed time
            prevT = curT;
            % print progress
            fprintf('[%s]\t', datetime('now', 'format', 'HH:mm:ss'));
            fprintf('Sim time:\t%i/%i ms\t\t iter: %i\n', curT, Tend, numIters);
        end

        % handle the abort file
        ac = fileread(abortFileName);

        if ~isempty(ac)
            ac = ac(1);
        end

        if ac == 'Y'
            STOPCONDITION = true;
        end

        % handle the status, 1=stop, 0=continue
        if STOPCONDITION
            status = 1;
        else
            status = 0;
        end

        % update the abortfile
        try
            update_abort_file(abortFileName);
        catch ME
            if strcmp(ME.identifier, 'MATLAB:badfid_mx')
                fprintf('Could not write file.\n')
            end
        end

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
