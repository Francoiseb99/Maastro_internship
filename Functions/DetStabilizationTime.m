% function [StabilizationTime,StabilizationTimeV2] = DetStabilizationTime(DepthArray,TimeArray)
	% This function can be used to obtain the warm up time needed by the
	% Azure Kinect DK to stabelize in its predictions. Note that different
	% aspects can be taken into account and therefore a preference needs to
	% be set by the user. In addition a stabilization percentage needs to
	% be chosen, this is used to determine the maximum variation between
	% points in time to be considered stable and is based on the minimum
	% and maximum encountered values.
    %
    % Veriable(s):
    %   DepthArray: the array with depth data averaged per minute
    %   TimeArray: the array with time data (minutes)

    %% Testing
    % Use this if you want to run it outside a function for testing
    % purposes
    
    DepthArray = meanMDL_5;
    TimeArray = time_min_5;
    
    %% Extra settings / options
    UseEndDepth = 0;
    UseMaxDepth = 1;
    UseRelative = 1;
    
    StabilizationPercentage = 99.5;
    ManualStabDiv = 0.001;
    
    %% Determine stabilization time
    MaxDepth = max(DepthArray);
    MinDepth = min(DepthArray);
     
    if UseRelative == 1
        StabDiv = (MaxDepth - MinDepth)*((100 - StabilizationPercentage) / 100);

        if UseEndDepth == 0 && UseMaxDepth == 0
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv 

                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end   

        elseif UseEndDepth == 1 && UseMaxDepth == 0
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv && abs(DepthArray(jj)-DepthArray(length(TimeArray)))<StabDiv 
                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end  
        elseif UseEndDepth == 0 && UseMaxDepth == 1
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv && abs(DepthArray(jj)-max(DepthArray))<StabDiv

                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end   

        elseif UseEndDepth == 1 && UseMaxDepth == 1
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv && abs(DepthArray(jj)-DepthArray(length(TimeArray)))<StabDiv && abs(DepthArray(jj)-max(DepthArray))<StabDiv 
                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end  
        end
    elseif UseRelative == 0
        StabDiv = ManualStabDiv;
        if UseEndDepth == 0 && UseMaxDepth == 0
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv 

                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end   

        elseif UseEndDepth == 1 && UseMaxDepth == 0
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv && abs(DepthArray(jj)-DepthArray(length(TimeArray)))<StabDiv 
                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end  
        elseif UseEndDepth == 0 && UseMaxDepth == 1
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv && abs(DepthArray(jj)-max(DepthArray))<StabDiv

                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end   

        elseif UseEndDepth == 1 && UseMaxDepth == 1
            for jj=6:length(TimeArray)-10
                if abs(DepthArray(jj)-DepthArray(jj-5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+5))<StabDiv && abs(DepthArray(jj)-DepthArray(jj+10))<StabDiv && abs(DepthArray(jj)-DepthArray(length(TimeArray)))<StabDiv && abs(DepthArray(jj)-max(DepthArray))<StabDiv 
                    StabilizationTime = TimeArray(jj-5) 
                    break
                end
            end  
        end      
        
    end
% end