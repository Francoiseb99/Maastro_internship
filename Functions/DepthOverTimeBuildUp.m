function [Matrix2, Matrix3] = DepthOverTimeBuildUp(DepthArrays,TimeArray)
	% This function returns a plot with the average difference of the
	% depth at a specific time relative to the final depth and relative to
	% the maximum encountered depth. In addition also a plot with the
	% standard deviation is shown. Lastly two matrices are returned showing
	% the build up in percentages for the given intervals. The first
	% matrix bases its values on the average of the first interval, whereas
	% the second matrix bases its values on the average of the first
	% minute.
    %
    % Variable(s):
    %   DepthArrays: an array of arrays with depth data averaged per minute
    %   TimeArray: the array with time data (minutes)    

    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes.
%     [meanMDL_1,meanMDL_2,meanMDL_3,meanMDL_4,meanMDL_5,time_min_1] = ExtractData();
%     DepthArrays = [meanMDL_1;meanMDL_2;meanMDL_3;meanMDL_4;meanMDL_5];
%     TimeArray = time_min_1;
    
    %% Extra settings / options
    
    % Choose to use an interval (true) or an average between the interval
    % times (false).
    Interval = true;
    
    % In both cases an interval time needs to be chosen:
    IntervalTime = 15;  % Suggestions: 15 or 60 minutes
    
    %% Create matrix with the desired data
    
    % Create a matrix with desired data for all time points for each depth
    % array.
    Matrix = [];
    for jj = 1:length(DepthArrays(:,1))
        MaxDepth = max(DepthArrays(jj,:));
        for ii = 1:length(TimeArray)
            TimePoint = TimeArray(ii);

            time = TimeArray(TimePoint);
            depth = DepthArrays(jj,TimePoint);
            DiffDepthMax = MaxDepth - depth;
            DiffDepthFinal = DepthArrays(jj,length(TimeArray)) - depth;

            Matrix = [Matrix; [jj, time, depth, DiffDepthMax, DiffDepthFinal]];
        end
    end

    % Assign empty lists
    depthAverageList = [];
    DiffDepthMaxAverageList = [];
    DiffDepthFinalAverageList = []; 
    
    depthStdList = [];
    DiffDepthMaxStdList = [];
    DiffDepthFinalStdList = [];   
    
    % Create initial interval window
    a=0;
    b=IntervalTime; 
    
    % Read out table and take averages over the different depth arrays to
    % put in the list.
    for ll = 1:(length(TimeArray)/IntervalTime)
        depthAverage = [];
        DiffDepthMaxAverage = [];
        DiffDepthFinalAverage = [];        
        for kk = 1:length(Matrix(:,1))
            if Interval == true && Matrix(kk,2)== b
                sub1_1 = Matrix(kk,3);
                sub1_2 = Matrix(kk,4);
                sub1_3 = Matrix(kk,5);
                depthAverage = [depthAverage;sub1_1];
                DiffDepthMaxAverage = [DiffDepthMaxAverage;sub1_2];
                DiffDepthFinalAverage = [DiffDepthFinalAverage;sub1_3];  
            elseif Interval == false && Matrix(kk,2)> a && Matrix(kk,2)<= b
                sub1_1 = Matrix(kk,3);
                sub1_2 = Matrix(kk,4);
                sub1_3 = Matrix(kk,5);
                depthAverage = [depthAverage;sub1_1];
                DiffDepthMaxAverage = [DiffDepthMaxAverage;sub1_2];
                DiffDepthFinalAverage = [DiffDepthFinalAverage;sub1_3];           
            end
        end
        sub2_1_1 = mean(depthAverage);
        sub2_2_1 = mean(DiffDepthMaxAverage);
        sub2_3_1 = mean(DiffDepthFinalAverage);
        sub2_1_2 = std(depthAverage);
        sub2_2_2 = std(DiffDepthMaxAverage);
        sub2_3_2 = std(DiffDepthFinalAverage);     

        depthAverageList = [depthAverageList;sub2_1_1];
        DiffDepthMaxAverageList = [DiffDepthMaxAverageList;sub2_2_1];
        DiffDepthFinalAverageList = [DiffDepthFinalAverageList;sub2_3_1];     

        depthStdList = [depthStdList;sub2_1_2];
        DiffDepthMaxStdList = [DiffDepthMaxStdList;sub2_2_2];
        DiffDepthFinalStdList = [DiffDepthFinalStdList;sub2_3_2];   

        a = a+IntervalTime; b = b+IntervalTime;
    end
    
    
    %% Plot figures
    Xaxis = 1:(length(TimeArray)/IntervalTime);

    f1 = figure;
    subplot(2,1,1);
    p1_1 = scatter(Xaxis, depthAverageList);
    hold on;
    p1_2 = scatter(Xaxis, DiffDepthMaxAverageList);
    hold on
    p1_3 = scatter(Xaxis, DiffDepthFinalAverageList);
    hold on
    
    ax1 = f1.CurrentAxes;
    xlim([0 max(time_min_1/IntervalTime)])
    title(ax1, 'Average depth difference with the maximum / final depth over time');
    xlabel(ax1, 'Time (IntervalTime minutes)');
    ylabel(ax1, 'Mean difference (mm)'); 
    hold off;

    lgd = legend([p1_1,p1_2,p1_3],{'Depth','Diff depth max', 'Diff depth final'},'Location','east');
    
    subplot(2,1,2);
    p2_1 = scatter(Xaxis, depthStdList);
    hold on;
    p2_2 = scatter(Xaxis, DiffDepthMaxStdList);
    hold on
    p2_3 = scatter(Xaxis, DiffDepthFinalStdList);
    hold on
    ax1 = f1.CurrentAxes;
    xlim([0 max(time_min_1/IntervalTime)])
    title(ax1, 'Std depth difference');
    xlabel(ax1, 'Time (IntervalTime minutes)');
    ylabel(ax1, 'Std (mm)'); 
    hold off
    
%% Table 
% This table gives percentages relative to first interval average
    Matrix2 = [0 0 0];
    for mm = 1:length(depthAverageList)
        percentage = ((depthAverageList(mm)-depthAverageList(1))/(depthAverageList(length(depthAverageList))-depthAverageList(1)))*100;
        Diff = percentage-Matrix2(mm,2);       
        Matrix2 = [Matrix2; Xaxis(mm) percentage Diff];
    end
    
    %% Table 2
    % Find average for first minute
    FirstMin = [];
    for nn = 1:length(Matrix(:,1))
        if Matrix(nn,2) == 1
           FirstMinSub = Matrix(nn,3);
           FirstMin = [FirstMin; FirstMinSub];
        end
    end
    FirstMinAvg = mean(FirstMin);
    
    % This table gives percentages relative to first minute average   
    Matrix3 = [0 0 0];
    for mm = 1:length(depthAverageList)
        percentage = ((depthAverageList(mm)-FirstMinAvg)/(depthAverageList(length(depthAverageList))-FirstMinAvg))*100;
        Diff = percentage-Matrix3(mm,2);       
        Matrix3 = [Matrix3; Xaxis(mm) percentage Diff];
    end    
end