% function Table = DepthOverTimeTable(DepthArray,TimeArray,TimePoints)
	% This function returns a table with the depths at the predefined
	% timepoints allong with the difference of this depth with the final
	% depth and with the maximum encountered depth.
    %
    % Veriable(s):
    %   DepthArray: the array with depth data averaged per minute
    %   TimeArray: the array with time data (minutes)    
    %   TimePoints: an array with desired timepoints for the table

    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    DepthArray = meanMDL_1;
    TimeArray = time_min_1;
    TimePoints = [1,10,30,60,120,240,480,555];
    
    %% Create matrix with the desired data
    MaxDepth = max(DepthArray);
    
    TimePoints = [TimePoints, length(TimeArray)];
    
    Matrix = [];
    for ii = 1:length(TimePoints)
        TimePoint = TimePoints(ii);
        
        time = TimeArray(TimePoint);
        depth = DepthArray(TimePoint);
        DivDepthMax = MaxDepth - depth;
        DivDepthFinal = DepthArray(length(TimeArray)) - depth;
        
        Matrix = [Matrix; [time, depth, DivDepthMax, DivDepthFinal]];
    end
    
    %% Make an actual table from the matrix
    Table = array2table(Matrix,'VariableNames',{'Time (min)','Depth','DivDepthMax', 'DivDepthFinal'});

% end