function ShowLiveImages(Depth, Color, IR)
	% This function provides a live stream of either the depth, color or
	% infrared data or a combination. Note that this function only gives 
    % live data and does not save anything. In addition, it should be noted 
    % that it does not have a predetermined end time, meaning the stream 
    % needs to be manually terminated.
    %
    % Variable(s):
    %   Depth: show depth data if available yes:1 or no:0
    %   Color: show color images if available yes:1 or no:0
    %   IR: show infrared images if available yes:1 or no:0

    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes.
    
%     clear all;        % If the function is used, make sure that the
%                       % workspace is clear before running the function
%     close all;
%     Depth = 1;
%     Color = 1;
%     IR = 1;
    
    %% Extra settings / options
    
    % Set to true if you want the range to be determined automatically based 
    % on first image, set to false if manually is prefered.
    AutomaticOutOfRange = false;     

    % Set minumum and maximum depth range in case the manual option is
    % chosen.
    MinimumDepth = 1500;
    MaximumDepth = 0;    
    
    %% Add Mex path
    addpath('C:/Users/20169037/AppData/Roaming/MathWorks/MATLAB Add-Ons/Collections/KinZ-Matlab/Mex');      %% Set path!
    
	%% Specify camera settings
    % Create KinZ object and initialize it
    % Available options: 
    % '720p', '1080p', '1440p', '1535p', '2160p', '3072p'
    % 'binned' or 'unbinned'
    % 'wfov' or 'nfov'
    % 'sensors_on' or 'sensors_off'
    
    kz = KinZ('720p', 'binned', 'wfov', 'imu_on');      %% Set preference!

    %% Image specifications
    % Images sizes
    depthWidth = kz.DepthWidth; 
    depthHeight = kz.DepthHeight; 
    colorWidth = kz.ColorWidth; 
    colorHeight = kz.ColorHeight;

    % Color image is to big, let's scale it down
    colorScale = 1;

    % Create matrices for the images
    depth = zeros(depthHeight,depthWidth,'uint16');
    color = zeros(colorHeight*colorScale,colorWidth*colorScale,3,'uint8');
    
    %% Find min and max depth
    % Here the minimum and maximum depth value are found for the first image,
    % based on this the range for displaying the other images is determined.
    
    if AutomaticOutOfRange == true
        % Depth stream figure
        f1 = figure;
        h1 = imshow(depth);
        ax1 = f1.CurrentAxes;
        title(ax1, 'Depth Source')
        colormap(ax1, 'Jet')
        colorbar(ax1)

        validData = kz.getframes('color','depth','infrared', 'imu');

        % Before processing the data, we need to make sure that a valid
        % frame was acquired.
        if validData 
            % Copy data to Matlab matrices        
            [depth, depth_timestamp] = kz.getdepth;

            % Update depth figure
            set(h1,'CData',depth); 
        end
        
        MaxDepth=max(max(depth));
        MinDepth=min(min(depth)); 
    else
        MaxDepth = MaximumDepth;         
        MinDepth = MinimumDepth;
    end

    %% Create figures
    if Depth == 1
        % Depth stream figure
        f1 = figure;
        h1 = imshow(depth,[MinDepth MaxDepth]);
        ax1 = f1.CurrentAxes;
        title(ax1, 'Depth Source')
        colormap(ax1, 'Jet')
        colorbar(ax1)
    end
    
    if Color == 1
        % Color stream figure
        f2 = figure;
        h2 = imshow(color,[]);
        ax2 = f2.CurrentAxes;
        title(ax2, 'Color Source');
        set(f2,'keypress','k=get(f2,''currentchar'');'); % Listen keypress
    end
    
    if IR == 1
        % Infrared stream figure
        f3 = figure;
        h3 = imshow(depth);
        ax3 = f3.CurrentAxes;
        title(ax3, 'Infrared Source')
    end    
    
    %% Acquire data
    while true
        % Get frames from Kinect and save them on underlying buffer
        % 'color','depth','infrared'
        validData = kz.getframes('color','depth','infrared', 'imu');

        % Before processing the data, we need to make sure that a valid
        % frame was acquired.
        
        if validData && Depth == 1
            % Copy data to Matlab matrices        
            [depth, depth_timestamp] = kz.getdepth;

            % Update depth figure
            set(h1,'CData',depth); 
        end
        
        if validData && Color == 1
            % Copy data to Matlab matrices        
            [color, color_timestamp] = kz.getcolor;

            % Update color figure
            color = imresize(color,colorScale);
            set(h2,'CData',color); 
        end
        
        if validData && IR ==1
            % Copy data to Matlab matrices 
            [infrared, infrared_timestamp] = kz.getinfrared;
            
            % Update infrared figure
            infrared = imadjust(infrared,[],[],0.5);
            set(h3,'CData',infrared); 
        end        
        
        pause(0.1)
    end    
end