function ShowDepthStdImage(SavedFrames, Color)
    % This function plays the depth and color footage created and saved by 
    % the function SaveImages and gives a standard deviation map of the 
    % depth values based on all frames taken. Displaying the color footage
    % is optional, the depth data is necessary for the standard deviation
    % map.
    %
    % Variable(s):
    %   SavedFrames: specify under what name the data is saved
    %   Color: show color images if available yes:1 or no:0
    
     
    
	%% Testing
    % Use this if you want to run it outside a function for testing
    % purposes.
    
%     close all;
    
%     SavedFrames = 'DBblock1.5mV1.mat';   
%     Color = 1;
    
    %% Extra settings / options
    
    % Set to true if you want the range to be determined automatically based 
    % on first image, set to false if manually is prefered.
    AutomaticOutOfRange = false;     

    % Set minumum and maximum depth range in case the manual option is
    % chosen.
    MinimumDepth = 1450;
    MaximumDepth = 1650;
    
    %% Add data path
    addpath('C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\Matlab arrays');
    
	%% Load data
    allData = load(SavedFrames);

    %% Specify which data is present and wanted
    Depth = 1;  % This is necessary, otherwise the function has no added value.
    
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
    %% Find min and max depth
    % Here the minimum and maximum depth value are found for the first image,
    % based on this the range for displaying the other images is determined.

    if AutomaticOutOfRange == true
        depth = allFramesDepth(:,:,1);

        MaxDepth=max(max(depth));
        MinDepth=min(min(depth)); 
    else
        MaxDepth = MaximumDepth;        
        MinDepth = MinimumDepth;
    end
 
    %% Create figures  
    
    if Depth_Show == 1
        % Depth stream figure
        f1 = figure;
        h1 = imshow(depth,[MinDepth MaxDepth]);
        ax1 = f1.CurrentAxes;
        title(ax1, 'Depth Source')
        colormap(ax1, 'Jet')
        colorbar(ax1)
    end
    
    if Color_Show == 1
        % Color stream figure
        f2 = figure;
        h2 = imshow(color,[]);
        ax2 = f2.CurrentAxes;
        title(ax2, 'Color Source');
        set(f2,'keypress','k=get(f2,''currentchar'');'); % Listen keypress
    end

    % Show data
    for i = 1:nrFrames-1 
        if Depth_Show == 1
           depth = allFramesDepth(:,:,i);
           set(h1,'CData',depth); 
           pause_time = (timestampsDepth(i+1) - timestampsDepth(i))*10e-10;
        end
        
        if Color_Show == 1
           color = rescale(allFramesColor(:,:,:,i));
           set(h2,'CData',color); 
           pause_time =(timestampsColor(i+1) - timestampsColor(i))*10e-10;
        end
        pause(pause_time);
    end   
    
    %% Std calculations and show image for depth data
    DepthStd = std(double(allFramesDepth),0,3);
    
    f3 = figure;
    imshow(DepthStd);
    ax3 = f3.CurrentAxes;
    title(ax3, 'Std map')
  
end