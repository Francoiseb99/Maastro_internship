% function DepthOverTime(nrFrames)
	% This function determines the average depth of an area over time. This
	% can be used to evaluate the precision of the camera over time. 
    % (Note that research has shown that this can take up to 40-50 minutes)
    % This function returns several plots:
    %   - A plot which gives the mean depth over the area for each frame
    %   - A plot which gives the mean depth over the area averaged per second
    %     including a plot which gives the standard deviation
    %   - A plot which gives the mean depth over the area averaged per
    %     minute including a plot which gives the standard deviation
    %   - A 3D plot including the time, the mean depth difference with the
    %     manually measured depth and the temperature of the camera
    %
    % Variable(s):
    %   nrFrames:   specify number of frames to determine duration of data
    %               acquiring (rough estimation gives 25-30 frames per second)


    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    clear all;          %when using the function instead of this testing section, 
    close all;          %make sure you also clear and close all before running the function
    nrFrames = 1000000;
    
    %% Extra settings / options
    
    % set to true if you want the range to be determined automatically based 
    % on first image, set to false if manually is prefered
    AutomaticOutOfRange = false;     

    % set minumum and maximum depth range in case the manual option is
    % chosen
    MinimumDepth = 0;
    MaximumDepth = 4000;
    
    % set to true if you want to get a live feed from the depth estimation 
    % (note that this plot may differ slightly from the final plot as it is 
    % based on the i value in the for loop and not the time)
    % (note that this LivePlot can cause a random error causing the code to 
    % stop (have not been able to solve this), hence it is not advised for
    % long runs)
    LivePlot = false;                

    % use this to adjust the name it is saved under
    % (note that this still gives some error during saving as the date is 
    % not represented correctly)
    Name = '08-08-2021'; Name = num2str(Name); 
    
    % Set actual depth here (measured by hand) (mm)
    ActualDepth = 1500;

    %% Add Mex path
    addpath('C:/Users/20169037/AppData/Roaming/MathWorks/MATLAB Add-Ons/Collections/KinZ-Matlab/Mex');      %% Set path!
    
	%% Specify camera settings
    % Create KinZ object and initialize it
    % Available options: 
    % '720p', '1080p', '1440p', '1535p', '2160p', '3072p'
    % 'binned' or 'unbinned'
    % 'wfov' or 'nfov'
    % 'sensors_on' or 'sensors_off'
    
    kz = KinZ('720p', 'unbinned', 'nfov', 'imu_on');      %% Set preference!

    %% Image specifications
    % Images sizes
    depthWidth = kz.DepthWidth; 
    depthHeight = kz.DepthHeight; 

    % Create matrices for the images
    depth = zeros(depthHeight,depthWidth,'uint16');

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
    
    %% Create figure
    % Depth figure to be used to determine region of interest
	f1 = figure;
	h1 = imshow(depth,[MinDepth MaxDepth]);
	ax1 = f1.CurrentAxes;
	title(ax1, 'Depth Source')
	colormap(ax1, 'Jet')
	colorbar(ax1)
    
    %% Acquire first data for determining region of interest
    % Get frames from Kinect and save them on underlying buffer
    % 'color','depth','infrared'
    validData = kz.getframes('color','depth','infrared', 'imu');

    % Before processing the data, we need to make sure that a valid
    % frame was acquired.
    if validData 
        % Copy data to Matlab matrices        
        [depth, depth_timestamp] = kz.getdepth;

        % Update depth figure
        set(h1,'CData',depth); 
    end
    
    %% Select region of interest
    %Take first image to select region of interest
	set(h1,'CData',depth);      
    
    [InterestRegion,rect]=imcrop;   %Select region of interest to be used for all other images throughout time
        
        %Note that you have to select this manually and use the right mouse
        %button to click on crop image before the code can continue
    
    %% Create figures 
   	% Depth stream figure for continuous footage
    f2 = figure;
	h2 = imshow(depth,[MinDepth MaxDepth]);
	ax2 = f2.CurrentAxes;
	title(ax2, 'Depth Source')
	colormap(ax2, 'Jet')
	colorbar(ax2)
    
    % Figure in which the mean depth of the region can be streamed continuously
    if LivePlot == true
        f = figure;
        ax = f.CurrentAxes;
        title(ax, 'Live mean depth');
    end
    
    %% Acquire data
    MeanDepthList=[];
    timestampsDepth=[];
    TempList = [];
        
    tic
    for i = 1:nrFrames
        % Get frames from Kinect and save them on underlying buffer
        % 'color','depth','infrared'
        validData = kz.getframes('color','depth','infrared', 'imu');

        % Before processing the data, we need to make sure that a valid
        % frame was acquired.
        if validData 
            % Copy data to Matlab matrices        
            [depth, depth_timestamp] = kz.getdepth;
            
            % Get sensor data
            sensorData = kz.getsensordata;
            temp = sensorData.temp;
            TempList = [TempList, temp];

            % Update depth figure
            set(h2,'CData',depth); 
            
            timestampsDepth = [timestampsDepth,depth_timestamp];
            %allFramesDepth(:,:,i)= depth;
            
            InterestRegion = imcrop(depth,rect);
            MeanDepthSub = mean(mean(InterestRegion)');
            MeanDepthList = [MeanDepthList, MeanDepthSub];
            
            % Update the live depth figure
            if LivePlot == true
                figure(f);
                plot(ax,(1:i),MeanDepthList);
            end
        end
                
        disp(i)
        pause(0.01)
        i=i+1;
    end       
    tictoc_time = toc       % To obtain the running time for the number of frames used (note this can differ slightly per run)
    
    %% Calculate MeanDepth of interest region
    MeanDepth = mean(MeanDepthList);    % Mean depth of region throughout whole run 

    %% Plot MeanDepth of the area against time
    f3=figure;
    time = (timestampsDepth - timestampsDepth(1));
    time_sec = double(time)*10^-9;
    h3 = plot(time_sec,MeanDepthList);
	ax3 = f3.CurrentAxes;
	title(ax3, 'Mean Depth against Time');
    xlabel(ax3, 'Time (sec)');
    ylabel(ax3, 'Depth (mm)');
    
    % Save image as a .fig file
    savename_fig = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\DepthOverTimePlot\Mean Depth against Time 10 hour run ', Name, '.fig');
    saveas(gcf,savename_fig)
    
    %% Plot MeanDepth of the area against time (per second version)
    MDL_sec = [];
    meanMDL_sec = [];
    stdMDL_sec = [];
    time_seconds = [];
    
    for m = 1:((ceil(tictoc_time))+1)       % Determine the number of seconds recorded and loop over this
        for q = 1:nrFrames
            if time_sec(q)>(m-1) && time_sec(q)<(m)     % Assign frames to the second at which it is recorded
                MDLsub_sec = MeanDepthList(q);
                MDL_sec = [MDL_sec, MDLsub_sec];
            end
            q=q+1;
        end
        % Calculate mean and std over each second
        meanMDLsub_sec = mean(MDL_sec);
        stdMDLsub_sec = std(MDL_sec);
        meanMDL_sec = [meanMDL_sec, meanMDLsub_sec];
        stdMDL_sec = [stdMDL_sec, stdMDLsub_sec];
        
        time_seconds_sub = m;
        time_seconds = [time_seconds, time_seconds_sub];
    end

    % Create subplot with (1) the average depth of the area and per second
    % and (2) the standard deviation per second
    f4=figure;
    subplot(2,1,1);
    h4 = plot(time_seconds,meanMDL_sec);
	ax4 = f4.CurrentAxes;
	title(ax4, 'Mean Depth against Time');
    xlabel(ax4, 'Time (seconds)');
    ylabel(ax4, 'Depth (mm)');    
    
    subplot(2,1,2);
    h4 = plot(time_seconds,stdMDL_sec);
	ax4 = f4.CurrentAxes;
	title(ax4, 'Std Depth against Time');
    xlabel(ax4, 'Time (seconds)');
    ylabel(ax4, 'Std depth (mm)'); 
    
    % Save image as a .fig file
    savename_fig = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\DepthOverTimePlot\Mean Depth against Time 10 hour run seconds version ', Name, '.fig');
    saveas(gcf,savename_fig)

    %% Plot MeanDepth against time (per minute version)
    MDL = [];
    meanMDL = [];
    stdMDL = [];
    time_min = [];
    
    for m = 1:((ceil(tictoc_time)/60)+1)       % Determine the number of minutes recorded and loop over this
        n=m*60;
        for q = 1:nrFrames
            if time_sec(q)>(n-60) && time_sec(q)<(n)     % Assign frames to the minute at which it is recorded
                MDLsub = MeanDepthList(q);
                MDL = [MDL, MDLsub];
            end
            q=q+1;
        end
        % Calculate mean and std over each minute
        meanMDLsub = mean(MDL);
        stdMDLsub = std(MDL);
        meanMDL = [meanMDL, meanMDLsub];
        stdMDL = [stdMDL, stdMDLsub];
        
        time_min_sub = m;
        time_min = [time_min, time_min_sub];
    end
    
    % Create subplot with (1) the average depth of the area and per minute
    % and (2) the standard deviation per minute
    f5=figure;
    subplot(2,1,1);
    plot(time_min,meanMDL);
	ax5 = f5.CurrentAxes;
	title(ax5, 'Mean Depth against Time');
    xlabel(ax5, 'Time (minutes)');
    ylabel(ax5, 'Depth (mm)');    
    
    subplot(2,1,2);
    plot(time_min,stdMDL);
	ax5 = f5.CurrentAxes;
	title(ax5, 'Std Depth against Time');
    xlabel(ax5, 'Time (minutes)');
    ylabel(ax5, 'Std depth (mm)');     

    % Save image as a .fig file
    savename_fig = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\DepthOverTimePlot\Mean Depth against Time 10 hour run minutes version ', Name, '.fig');
    saveas(gcf,savename_fig)
    
    %% Plot temperature against time and depth difference
    DepthDifference = MeanDepthList-ActualDepth;
    f6=figure;
    time = (timestampsDepth - timestampsDepth(1));
    time_sec = double(time)*10^-9;
    h6 = plot3(time_sec,TempList,DepthDifference);
	ax6 = f6.CurrentAxes;
	title(ax6, 'Mean Depth against Time');
    xlabel(ax6, 'Time (sec)');
    ylabel(ax6, 'Temperature (degrees celsius)');
    zlabel(ax6, 'Depth difference (mm)');
    
    % Use this to view the axis specifically
%     play = true;
%     while play == true
%         view(0,90)  % XY
%         pause(2)
%         view(0,0)   % XZ
%         pause(2)
%         view(90,0)  % YZ
%         pause(2)
%     end
     
    % Save image as a .fig file
    savename_fig = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\DepthOverTimePlot\Temperature against Time and Depth Difference 10 hour run ', Name, '.fig');
    saveas(gcf,savename_fig)
    
    %% Plot MeanDepth of the area against Temperature (per second version)
    MDL_temp = [];
    meanMDL_temp = [];
    stdMDL_temp = [];
    temp = [];
    
    for m = 12:26       % Determine the number of seconds recorded and loop over this
        for q = 1:nrFrames
            if TempList(q)>(m-1) && TempList(q)<(m)     % Assign frames to the second at which it is recorded
                MDLsub_temp = MeanDepthList(q);
                MDL_temp = [MDL_temp, MDLsub_temp];
            end
            q=q+1;
        end
        % Calculate mean and std over each second
        meanMDLsub_sec = mean(MDL_temp);
        stdMDLsub_sec = std(MDL_temp);
        meanMDL_temp = [meanMDL_temp, meanMDLsub_sec];
        stdMDL_temp = [stdMDL_temp, stdMDLsub_sec];
        
        time_seconds_sub = m;
        temp = [temp, time_seconds_sub];
    end

    % Create subplot with (1) the average depth of the area and per second
    % and (2) the standard deviation per second
    f7=figure;
    subplot(2,1,1);
    h7 = plot(temp,meanMDL_temp);
	ax7 = f7.CurrentAxes;
	title(ax7, 'Mean Depth against Temperature');
    xlabel(ax7, 'Temperature (degrees Celcius)');
    ylabel(ax7, 'Depth (mm)');    
    
    subplot(2,1,2);
    h7 = plot(temp,stdMDL_temp);
	ax7 = f7.CurrentAxes;
	title(ax7, 'Std Depth against Temperature');
    xlabel(ax7, 'Temperature (degrees Celcius)');
    ylabel(ax7, 'Std depth (mm)'); 
    
    % Save image as a .fig file
    savename_fig = sprintf ( '%s%i%s', 'C:\Users\20169037\Documents\BMT\Vakken\Jaar 4\Q4\Stage\DepthOverTimePlot\  ', Name, '.fig');
    saveas(gcf,savename_fig)
   
    %% Determine min, max, corresponding time and total footage running time
    text1 = 'The minimum encountered average depth was ';
    [minimum,index1] = min(MeanDepthList);
    time1 = (timestampsDepth(index1) - timestampsDepth(1))*10e-10;
    text2 = ' around ';
    text3 = ' seconds. The maximum encountered average depth was ';
    [maximum,index2] = max(MeanDepthList);
    time2 = (timestampsDepth(index2) - timestampsDepth(1))*10e-10;
    text4 = ' around ';
    text5 = ' seconds. The total running time was ';
    text6 = ' seconds, which is ';
    tictoc_time_min = floor(tictoc_time/60);
    text7 = ' minutes and ';
    tictoc_time_remsec = ((tictoc_time)/60-tictoc_time_min)*60;
    text8 = ' seconds. The encountered temperature difference is ';
    TempDiff = TempList(end)-TempList(1);
    text9 = ' degrees celcius.';
    X = [text1,num2str(minimum),text2,num2str(time1),text3,num2str(maximum),text4,num2str(time2),text5,num2str(tictoc_time), text6,num2str(tictoc_time_min),text7,num2str(tictoc_time_remsec),text8,num2str(TempDiff),text9];
    
    disp(X)

% end