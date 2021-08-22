function SaveImagesV2(filename, Depth, Color, IR)
    % This function makes a recording using the Azure Kinect DK and saves
    % the data under a specified filename. It can be chosen to include
    % depth images and / or color and / or IR images. It is an augmented
    % version of SaveImages. Differences with the functions SaveImages
    % and ShowSavedImages are the fact that the V2 versions include
    % not making use of the interval times based on the actuall
    % interval but rather a pre-set interval time and slightly different
    % variablenames so the data can be used for the runDetection.m file
    % from Nick Staut.
    %
    % Variable(s):
    %   filename: specify under what name the data should be saved
    %   Depth: acquire depth data yes:1 or no:0
    %   Color: acquire color images yes:1 or no:0
    %   IR: acquire infrared images yes:1 or no:0
 
    close all;
    
    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes.
    
%     filename = 'CalibrationBunkerV2.mat';   
%     Depth = 1;
%     Color = 1;
%     IR = 1;
    
    %% Extra settings / options
    
    % Set to true if you want the range to be determined automatically based 
    % on first image, set to false if manually is prefered.
    AutomaticOutOfRange = false;     

    % Set minumum and maximum depth range in case the manual option is
    % chosen.
    MinimumDepth = 0;
    MaximumDepth = 5000;
    
    % Set number of frames to be taken.
    nrFrames=200;   
    
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

    %% Find min and max depth
    % Here the minimum and maximum depth value are found for the first image,
    % based on this the range for displaying the other images is determined.
    
    if AutomaticOutOfRange == true
        depth = zeros(depthHeight,depthWidth,'uint16');
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
    infrared = zeros(depthHeight,depthWidth,'uint16');
    color = zeros(colorHeight*colorScale,colorWidth*colorScale,3,'uint8');

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
        h3 = imshow(infrared);
        ax3 = f3.CurrentAxes;
        title(ax3, 'Infrared Source');
    end
    
    pause(2)    % Gives you some extra time
    
    %% Acquire data
    timestampsDepth=zeros(size(nrFrames));
    allFramesDepth=uint16(zeros(depthHeight, depthWidth, nrFrames));
	allFramesColor=uint16(zeros(colorHeight*colorScale,colorWidth*colorScale,3, nrFrames));
    allFramesIR = uint16(zeros(depthHeight, depthWidth, nrFrames));
    
    for i = 1:nrFrames
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
            
            timestampsDepth(i) = depth_timestamp;
            allFramesDepth(:,:,i)= depth;
        end
        
        if validData && Color == 1
            % Copy data to Matlab matrices        
            [color, color_timestamp] = kz.getcolor;

            % Update color figure
            color = imresize(color,colorScale);
            set(h2,'CData',color); 
            
            timestampsColor(i) = color_timestamp;
            allFramesColor(:,:,:,i)= color;
        end
        
        if validData && IR ==1
            % Copy data to Matlab matrices 
            [infrared, infrared_timestamp] = kz.getinfrared;
            
            % Update infrared figure
            infrared = imadjust(infrared,[],[],0.5);
            set(h3,'CData',infrared); 
            timestampsIR(i) = infrared_timestamp;
            allFramesIR(:,:,i)= infrared;
        end
        
        disp(i)
        pause(0.5)
    end    
    
    %% Save files
    DepthFrames = allFramesDepth;
    ColorFrames = allFramesColor;
    InfraredFrames = allFramesIR;
    
    if Depth == 1 && Color == 1 && IR == 1
        save(filename, 'DepthFrames', 'ColorFrames','InfraredFrames')
    elseif Depth == 1 && Color == 1 && IR == 0
        save(filename, 'DepthFrames','ColorFrames')
    elseif Depth == 1 && Color == 0 && IR == 1
        save(filename, 'DepthFrames','InfraredFrames')
    elseif Depth == 0 && Color == 1 && IR == 1
        save(filename, 'ColorFrames','InfraredFrames') 
    elseif Depth == 1 && Color == 0 && IR == 0
        save(filename, 'DepthFrames')
    elseif Depth == 0 && Color == 1 && IR == 0
        save(filename, 'ColorFrames') 
    elseif Depth == 0 && Color == 0 && IR == 1
        save(filename, 'InfraredFrames')     
    end
    
    %% Clear all variables after saving for next use
    clear all;      % This can be commented out, however you'll have to do it manually before next use

end