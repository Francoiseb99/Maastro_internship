% function ShowOrientation(Duration, Filename)
	% This function provides a live plot of the orientation of the camera
	% starting out in flat position. It takes the data from the internal
	% gyroscope (angle speed) and plots this. However, this function proved 
    % that this gyroscope is not entirely correct as even when there is no 
    % movement, the plot keeps rotating.
    %
    % Variable(s):
    %   Duration: desired duration of obtaining data (in minutes)
    %   Filename: filename under which relevant data should be saved
    
    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes.
    
    clear all;        % If the function is used, make sure that the
                      % workspace is clear before running the function
    close all;
    Duration = 250;
    Filename = "Orientation_horizontal_run2.mat";

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
    
    %% Create initial cube (representing the camera)
    A = [0 0 0];
    B = [2 0 0];
    C = [0 1 0];
    D = [0 0 1];
    E = [0 1 1];
    F = [2 0 1];
    G = [2 1 0];
    H = [2 1 1];
    P = [A;B;F;H;G;C;A;D;E;H;F;D;E;C;G;B];
    
    %% Create figures
    % Create cube in flat position
    f1 = figure;
    h1 = plot3(P(:,1),P(:,2),P(:,3));
    grid on;
    xlabel('x')
    ylabel('y')
    zlabel('z')
    title('Flat Camera Orientation');

    % Create cube to be rotated
    f2 = figure;
    h2 = plot3(P(:,1),P(:,2),P(:,3));
    
    % Create plot total orientation over time
    f3 = figure;
    
    %% Acquire data
    pitch_new = 0;
    yaw_new = 0;
    roll_new = 0;  
    time = 0;

    pitch_list = [];
    yaw_list = [];
    roll_list = [];
    time_list = [];  
    tictoc_list = [];
    
    tictoc = 0;
    
    tic
    while tictoc/60 < Duration
        % Get imu data
        validData = kz.getframes('imu');

        % Before processing the data, we need to make sure that a valid
        % frame was acquired.
        if validData
            % Copy data to Matlab matrices        
            sensorData = kz.getsensordata;
        
            % Obtain data and calculate summation 
            pitch = sensorData.gyro_x;
            yaw = sensorData.gyro_y;
            roll = sensorData.gyro_z;
            
            pitch_new = pitch_new + pitch;
            yaw_new = yaw_new + yaw;
            roll_new = roll_new + roll;
            
            dcm = angle2dcm(yaw_new, pitch_new, roll_new);
            P_new = P*dcm;
            
            % Plot orientation            
            figure(f2);
            plot3(P_new(:,1),P_new(:,2),P_new(:,3));  
            grid on;
            title('Camera Orientation');
            xlabel('x')
            ylabel('y')
            zlabel('z')
            
            % Plot orientation over time
            pitch_list = [pitch_list, pitch_new];
            yaw_list = [yaw_list, yaw_new];
            roll_list = [roll_list, roll_new];
            
            time_list = [time_list, time];

            figure(f3);
            plot(time_list,pitch_list); 
            hold on;
            plot(time_list,yaw_list); 
            hold on;
            plot(time_list,roll_list); 
            hold off;
            title('Gyroscope Output against Time');
            xlabel('Frame');
            ylabel('Gyroscope output');
            
            % Show sensor data
            disp('------------ Sensors Data ------------')
            disp(['Temp: ' num2str(sensorData.temp)]);
            disp(['acc_x: ' num2str(sensorData.acc_x)]);
            disp(['acc_y: ' num2str(sensorData.acc_y)]);
            disp(['acc_z: ' num2str(sensorData.acc_z)]);
            disp(['acc_timestamp: ' num2str(sensorData.acc_timestamp_usec)]);
            disp(['gyro_x: ' num2str(sensorData.gyro_x)]);
            disp(['gyro_y: ' num2str(sensorData.gyro_y)]);
            disp(['gyro_z: ' num2str(sensorData.gyro_z)]);
            disp(['gyro_timestamp: ' num2str(sensorData.gyro_timestamp_usec)]);
        end
        
        time = time+1;
        
        pause(1)
        tictoc = toc
        tictoc_list = [tictoc_list, tictoc];
    end    
    
    
    %% Make final plot
    time_sec = linspace(1,tictoc/60,(length(time_list)));
    
    f4 = figure;
    p1 = plot(time_sec,pitch_list); 
    hold on;
    p2 = plot(time_sec,yaw_list); 
    hold on;
    p3 = plot(time_sec,roll_list); 
    hold off;
    grid on;
    title('Gyroscope Output against Time');
    xlabel('Time (min)');
    ylabel('Gyroscope output (degrees)');
    xlim([0 max(time_sec)])
    set(gca,'XTick',(0:20:max(time_sec)))
    lgd = legend([p1, p2, p3], {'Pitch', 'Yaw', 'Roll'}, 'location', 'northwest');
    
    %% Save relevant data
    save(Filename, 'pitch_list', 'roll_list', 'yaw_list', 'time_list', 'time_sec')
    
% end