function SaveImages(filename, Depth, Color)
    % This function makes a recording using the Azure Kinect DK and saves
    % the data under a specified filename. It can be chosen to include
    % depth images and / or color images.
    %
    % Veriable(s):
    %   filename: specify under what name the data should be saved
    %   Depth: acquire depth data yes:1 or no:0
    %   Color: acquire color images yes:1 or no:0
    %
    %
    % Original code belonged to: 
    % Juan R. Terven, jrterven@hotmail.com & Diana M. Cordova, diana_mce@hotmail.com
        
    close all;
    
    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    
    %filename = 'filename.mat';   
    %Depth = 1;
    %Color = 0;
    
    %% Add Mex path
    addpath('C:/Users/20169037/AppData/Roaming/MathWorks/MATLAB Add-Ons/Collections/KinZ-Matlab/Mex');      %% Set path!
    
	%% Specify camera settings
    % Create KinZ object and initialize it
    % Available options: 
    % '720p', '1080p', '1440p', '1535p', '2160p', '3072p'
    % 'binned' or 'unbinned'
    % 'wfov' or 'nfov'
    % 'sensors_on' or 'sensors_off'
    
    kz = KinZ('720p', 'binned', 'nfov', 'imu_on');      %% Set preference!

    %% Image specifications
    % Images sizes
    depthWidth = kz.DepthWidth; 
    depthHeight = kz.DepthHeight; 
    outOfRange = 5000;                                  %% Set preference!
    colorWidth = kz.ColorWidth; 
    colorHeight = kz.ColorHeight;

    % Color image is to big, let's scale it down
    colorScale = 1;

    % Create matrices for the images
    depth = zeros(depthHeight,depthWidth,'uint16');
    color = zeros(colorHeight*colorScale,colorWidth*colorScale,3,'uint8');

    %% Create figures
    if Depth == 1
        % Depth stream figure
        f1 = figure;
        h1 = imshow(depth,[0 outOfRange]);
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
    
    %% Acquire data
    nrFrames=100;                                       %% Set preference!
    timestampsDepth=zeros(size(nrFrames));
    allFramesDepth=uint16(zeros(depthHeight, depthWidth, nrFrames));
	allFramesColor=uint16(zeros(colorHeight*colorScale,colorWidth*colorScale,3, nrFrames));

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
        
        disp(i)
        pause(0.01)
    end    
    
    %% Save files
    if Depth == 1 && Color == 1
        save(filename, 'allFramesDepth', 'allFramesColor', 'timestampsDepth', 'timestampsColor')
    elseif Depth == 1 && Color == 0
        save(filename, 'allFramesDepth', 'timestampsDepth')
    elseif Depth == 0 && Color == 1
        save(filename, 'allFramesColor', 'timestampsColor')
    end
    
    %% Clear all variables after saving for next use
    clear all;      % This can be taken out, however you'll have to do it manually before next use

end
