% function point = OptimumWarmUpTime(DepthArrays,TimeArray)
	% This function returns the optimum warm up time for the azure kinect
	% based on the slope coefficient. 
    %
    % Variable(s):
    %   DepthArrays: an array of arrays with depth data averaged per minute
    %   TimeArray: the array with time data (minutes)    

    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    
    [meanMDL_1,meanMDL_2,meanMDL_3,meanMDL_4,meanMDL_5,time_min_1] = ExtractData();
    DepthArrays = [meanMDL_1;meanMDL_2;meanMDL_3;meanMDL_4;meanMDL_5];
    TimeArray = time_min_1;
    
    %% Create matrix with the desired data
    
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
    
    %% Create average lists over the multiple depth arrays
    
    % Create empty lists
    DiffDepthMaxList = [];
    DiffDepthFinalList = [];
    DiffDepthMaxStdList = [];
    DiffDepthFinalStdList = [];    
    SubAvgs1 = [];
    SubAvgs2 = [];
    
    for gg = 1:length(TimeArray)
        dd = gg;
        for kk = 1:length(DepthArrays(:,1))
            SubAvg1 = Matrix(dd,4);
            SubAvgs1 = [SubAvgs1, SubAvg1];
            SubAvg2 = Matrix(dd,5);
            SubAvgs2 = [SubAvgs2, SubAvg2];            
            dd = gg + length(TimeArray);
        end
        DiffDepthMaxSub = mean(SubAvgs1);
        DiffDepthMaxList = [DiffDepthMaxList, DiffDepthMaxSub];
        
        DiffDepthMaxStdSub = std(SubAvgs1);
        DiffDepthMaxStdList = [DiffDepthMaxStdList, DiffDepthMaxStdSub];
        
        DiffDepthFinalSub = mean(SubAvgs2);
        DiffDepthFinalList = [DiffDepthFinalList, DiffDepthFinalSub];     

        DiffDepthFinalStdSub = std(SubAvgs2);
        DiffDepthFinalStdList = [DiffDepthFinalStdList, DiffDepthFinalStdSub];        
    end
    
    %% Create figure for average depth difference over time and accompanying std graph
    
    f1 = figure;
    subplot(2,1,1);
    p1_1 = plot(TimeArray, DiffDepthMaxList);
    hold on;
    p1_2 = plot(TimeArray, DiffDepthFinalList);
    hold on
    
    ax1 = f1.CurrentAxes;
    xlim([0 max(time_min_1)])
    title(ax1, 'Average depth difference with the maximum / final depth over time');
    xlabel(ax1, 'Time (minutes)');
    ylabel(ax1, 'Mean difference (mm)'); 
    hold off;

    lgd = legend([p1_1,p1_2],{'Difference relative to maximum encountered value','Difference relative to final value'},'Location','northeast');
    
    subplot(2,1,2);
    p2_1 = plot(TimeArray, DiffDepthMaxStdList);
    hold on;
    p2_2 = plot(TimeArray, DiffDepthFinalStdList);
    hold on
    ax1 = f1.CurrentAxes;
    xlim([0 max(time_min_1)])
    title(ax1, 'Std depth difference');
    xlabel(ax1, 'Time (minutes)');
    ylabel(ax1, 'Std (mm)'); 
    hold off
    
    %% Find optimum time
    
    f2 = figure;
    x = TimeArray;
    y = DiffDepthMaxList;   % or use: y = DiffDepthFinalList; it should not differ (much)
    
    % Take the derivative
    dydx = (gradient(y) ./ gradient(x));  
    
    % Determine geneeral coefficient based on start and end point
    b = (y(end)-y(1))/(x(end)-x(1));
    
    % Determine point with equal coefficient to general coefficient
    point = find((dydx < b +0.00001) & (dydx > b -0.00001));
    
    % Determine starting point 
    a = y(point) - b*point;
    
    % Determine function based on a and b with intersection of point "point"
    func = a+b*x;
    
    % Plot actual line and intersection line. Everything before the
    % intersection has a bigger slope value.
    plot(x, y);
    hold on;
    plot(x, func);
    hold on;
    scatter(point, y(point), 'filled');
    hold off;
    
    
    %% Total plot
    
    f3 = figure;
    subplot(2,1,1);
    p1_1 = plot(TimeArray, DiffDepthMaxList);
    hold on;
    p1_2 = plot(TimeArray, DiffDepthFinalList);
    hold on;
    p1_3 = plot(x, func);
    hold on;
    p1_4 = scatter(point, y(point), 'filled');
    grid on;
    
    ax3 = f3.CurrentAxes;
    xlim([0 max(time_min_1)])
    title(ax3, 'Average depth difference with the maximum / final depth over time');
    xlabel(ax3, 'Time (minutes)');
    ylabel(ax3, 'Mean difference (mm)'); 
    set(gca,'YTick',(-0.2:0.2:0.8))
    hold off;

    lgd = legend([p1_1,p1_2,p1_3,p1_4],{'Difference relative to maximum encountered value','Difference relative to final value','Average gradient line','Inflection point'},'Location','northeast');
    
    subplot(2,1,2);
    p2_1 = plot(TimeArray, DiffDepthMaxStdList);
    hold on;
    p2_2 = plot(TimeArray, DiffDepthFinalStdList);
    grid on;
    
    ax3 = f3.CurrentAxes;
    xlim([0 max(time_min_1)])
    title(ax3, 'Std depth difference');
    xlabel(ax3, 'Time (minutes)');
    ylabel(ax3, 'Std (mm)'); 
    hold off;
% end