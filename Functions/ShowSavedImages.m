function ShowSavedImages(SavedFrames, Depth, Color, IR)
    % This function plays the footage created and saved by the function
    % SaveImages. Which data is shown (Depth and/or Color and/or IR) 
    % depends on which data is present in the file and which data is wanted 
    % by the user.
    %
    % Variable(s):
    %   SavedFrames: specify under what name the data is saved
    %   Depth: show depth data if available yes:1 or no:0
    %   Color: show color images if available yes:1 or no:0
    %   IR:    show infrared images if available yes:1 or no:0
    
    close all; 
    
	%% Testing
    % Use this if you want to run it outside a function for testing
    % purposes.
    
    %SavedFrames = 'filename2.mat';   
    %Depth = 1;
    %Color = 1;
    %IR = 1;
    
    %% Extra settings / options
    
    % Set to true if you want the range to be determined automatically based 
    % on first image, set to false if manually is prefered.
    AutomaticOutOfRange = false;     

    % Set minumum and maximum depth range in case the manual option is
    % chosen.
    MinimumDepth = 2950;
    MaximumDepth = 3050;
    
    %% Add data path
    addpath('C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\Matlab arrays');
    
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
    
    if isfield(allData, 'allFramesIR') && IR == 1
        IR_Show = 1;
    else
        if IR == 1
           disp('Infrared data not present in file and is therefore not shown.')
        end
        IR_Show = 0;
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
    
	if IR_Show == 1
        allFramesIR=allData.allFramesIR;
        timestampsIR=allData.timestampsIR;
        infraredHeight = size(allFramesIR,1);
        infraredWidth = size(allFramesIR,2);
        nrFrames = size(allFramesIR,3);
        
        infrared = zeros(infraredHeight,infraredWidth,'uint16');
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

    if IR_show == 1
        % Infrared stream figure
        f3 = figure;
        h3 = imshow(infrared);
        ax3 = f3.CurrentAxes;
        title(ax3, 'Infrared Source');
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
        
        if IR_Show == 1
           infrared = allFramesIR(:,:,i);
           set(h3,'CData',infrared); 
           pause_time = (timestampsIR(i+1) - timestampsIR(i))*10e-10;
        end
        
        pause(pause_time);
    end   
end