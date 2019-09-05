function saveVideo(F, filePath, fps)
    %SAVEVIDEO saves a bunch of frames to a video file.
    %
    %   saveVideo(F, filePath, fps)
    %   
    %   Input arguments:
    %       F               struct with frame data (fields: cdata, colormap)
    %       filePath        output file path
    %       fps             frame rate, default 30 fps
    %
    %   RW, someday-somemonth-2019

    if ~exist('fps', 'var')
        fps = 30;
    end

    % save animation
    writerObj = VideoWriter(filePath, 'MPEG-4');
    writerObj.FrameRate = fps;

    % open the video writer
    open(writerObj);
    % write the frames to the video
    disp('Writing video file')

    for ii = 1:length(F)
        % convert the image to a frame
        frame = F(ii);

        if isempty(frame.cdata)
            break;
        else

            writeVideo(writerObj, frame);
        end

    end

    close(writerObj);

    fprintf('Done! video saved as: \n\t%s\n\n', filePath)

end
