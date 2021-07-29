%function GetSeparateImages(SavedFrames, Depth, Color)
    % This function converts all frames from SavedFrames to seperate PNG
    % images (can be adjusted to another format if preferred) images which 
    % could be used e.g. for calibration purposes. Note that the 
    % destination should be manually specified at the end of the file.
    % 
    %
    % Veriable(s):
    %   SavedFrames: specify under what name the data is saved
    %   Depth: show depth data if available yes:1 or no:0
    %   Color: show color images if available yes:1 or no:0
    
    close all; 
    
    %% Add data path
    addpath('C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\Matlab arrays');
    
	%% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    
    SavedFrames = '28-05 calibration 1';   
    Depth = 1;
    Color = 1;
    %Calibration_path adjust this one further down in the file
    
	%% Load data
    allData = load(SavedFrames);

    %% Specify which data is present and wanted
    if isfield(allData, 'allFramesDepth') && Depth == 1
        Depth_Show = 1;
    else
        if Depth == 1
           disp('Depth data not present in file and is therefore not shown.')
        end
        Depth_Show = 0;
    end
    
    
    if isfield(allData, 'allFramesColor') && Color == 1
        Color_Show = 1;
    else
        if Color == 1
           disp('Color data not present in file and is therefore not shown.')
        end
        Color_Show = 0;
    end
     
    %% Take the data from the structure and create matrices for images
	if Depth_Show == 1
        allFramesDepth=allData.allFramesDepth;
        timestampsDepth=allData.timestampsDepth;
        depthHeight = size(allFramesDepth,1);
        depthWidth = size(allFramesDepth,2);
        nrFrames = size(allFramesDepth,3);
        
        depth = zeros(depthHeight,depthWidth,'uint16');
    end
    
	if Color_Show == 1
        allFramesColor=allData.allFramesColor;
        timestampsColor=allData.timestampsColor;
        colorHeight = size(allFramesColor,1);
        colorWidth = size(allFramesColor,2);
        nrFrames = size(allFramesColor,4);
        
        color = zeros(colorHeight,colorWidth,3,'uint8');
    end

    %% Save data
    for i = 1:nrFrames-1 
        if Depth_Show == 1
           depth = allFramesDepth(:,:,i);
           savename = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\22-06 Calibration 2\Depth\Depth', i, '.png');
           %save(savename, 'depth');
           depth = rescale(depth);
           imwrite(depth,savename,'PNG');
        end
        
        if Color_Show == 1
           color = rescale(allFramesColor(:,:,:,i));
           savename = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\22-06 Calibration 2\Color\Color', i, '.png');
           %save(savename, 'color');
           imwrite(color,savename,'PNG');
        end
    end       
%end

