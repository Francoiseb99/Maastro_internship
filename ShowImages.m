function ShowImages(SavedFrames, Depth, Color)
    % This function plays the footage created and saved by the function
    % SaveImages. Which data is shown (Depth and/or Color) depends on which
    % data is present in the file and which data is wanted by the user.
    %
    % Veriable(s):
    %   SavedFrames: specify under what name the data is saved
    %   Depth: show depth data if available yes:1 or no:0
    %   Color: show color images if available yes:1 or no:0
    
    close all; 
    
	%% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    
    SavedFrames = 'filename.mat';   
    Depth = 1;
    Color = 1;
    
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

    %% Create figures  
    outOfRange = 5000;
    
    if Depth_Show == 1
        % Depth stream figure
        f1 = figure;
        h1 = imshow(depth,[0 outOfRange]);
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

    %% Show data
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
end