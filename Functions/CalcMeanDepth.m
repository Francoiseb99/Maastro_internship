function MeanDepth = CalcMeanDepth(SavedFrames)
    % This function can be used for an experiment where the mean depth of
    % an object needs to be determined. The region of interest can be
    % specified by the user afterwhich it will calculate the mean depth
    % over the area over time.
    %
    % Veriable(s):
    %   SavedFrames: specify under what name the data is saved

    %% Add data path
    addpath('C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\Matlab arrays');
    
    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    
    %SavedFrames = "DistAcc45.mat";
    
    
	%% Load data
    allData = load(SavedFrames);
	
    %% Take the data from the structure and create matrices for images
    allFramesDepth=allData.allFramesDepth;
	timestampsDepth=allData.timestampsDepth;
	depthHeight = size(allFramesDepth,1);
	depthWidth = size(allFramesDepth,2);
	nrFrames = size(allFramesDepth,3);
    depth = zeros(depthHeight,depthWidth,'uint16');    
    
    %% Find min and max depth
    % Here the minimum and maximum depth value are found for the first image,
    % based on this the range for displaying the other images is determined.
    
    AutomaticOutOfRange = true;     %set to true if you want the range to be determined automatically based on first image, set to false if manually is prefered
    
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
        MaxDepth = 1500;         %set preference when not using automated method
        MinDepth = 0;
    end
    
    %% Create figure 1
	% Depth stream figure
	f1 = figure;
	h1 = imshow(depth,[MinDepth MaxDepth]);
	ax1 = f1.CurrentAxes;
	title(ax1, 'Depth Source')
	colormap(ax1, 'Jet')
	colorbar(ax1)

    %% Select region of interest
	depth = allFramesDepth(:,:,1);  %Take first image to select region of interest
	set(h1,'CData',depth);      
    
    [InterestRegion,rect]=imcrop;   %Select region of interest to be used for all other images throughout time
        
        %Note that you have to select this manually and use the right mouse
        %button to click on crop image before the code can continue
        
    %% Create figure 2 
   	% Depth stream figure
    f2 = figure;
	h2 = imshow(depth,[MinDepth MaxDepth]);
	ax2 = f2.CurrentAxes;
	title(ax2, 'Depth Source')
	colormap(ax2, 'Jet')
	colorbar(ax2)
    
    %% Show data and obtain a list of mean depth values per image
    MeanDepthList=[];
    for i = 1:nrFrames-1 
        depth = allFramesDepth(:,:,i);
        
        InterestRegion = imcrop(depth,rect);
        MeanDepthSub = mean(InterestRegion);
        MeanDepthList = [MeanDepthList, MeanDepthSub];
        
        set(h2,'CData',depth); 
        pause_time = (timestampsDepth(i+1) - timestampsDepth(i))*10e-10;
        pause(pause_time);
    end      
    
    %% Calculate MeanDepth of interest region
    MeanDepth = mean(MeanDepthList);
    
end