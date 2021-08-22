function [meanMDL_1,meanMDL_2,meanMDL_3,meanMDL_4,meanMDL_5,time_min_1] = ExtractData()
    % This function is meant to extract data from subplots created in and 
    % saved by the function DepthOverTime.m. The figure names as well as
    % the actual distance are hardcoded per section, these can be changed 
    % in case it needs to be used for other data.         

    %% Data from 17-07-2021 -- 1500
    % Load figure data
    fig1 = openfig('Mean Depth against Time 10 hour run minutes version 17-07-2021.fig');

    % Extract data from first subplot
    subplot(2,1,1);
    axObjs = fig1.Children;
    dataObjs = axObjs(2).Children;
    time_min_1 = dataObjs(1).XData;
    meanMDL_1 = dataObjs(1).YData - 1500;   % Substract actual distance so the measurement error remains

    % Extract data from second subplot
    subplot(2,1,2);
    axObjs = fig1.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_1 = dataObjs(1).YData;

    %% Data from 18-07-2021 -- 1500
    % Load figure data
    fig2 = openfig('Mean Depth against Time 10 hour run minutes version 18-07-2021.fig');

    % Extract data from first subplot
    subplot(2,1,1);
    axObjs = fig2.Children;
    dataObjs = axObjs(2).Children;
    time_min_2 = dataObjs(1).XData;
    meanMDL_2 = dataObjs(1).YData - 1500;   % Substract actual distance so the measurement error remains

    % Extract data from second subplot
    subplot(2,1,2);
    axObjs = fig2.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_2 = dataObjs(1).YData;

    %% Data from 24-07-2021 -- 2000
    % Load figure data
    fig3 = openfig('Mean Depth against Time 10 hour run minutes version 24-07-2021.fig');

    % Extract data from first subplot
    subplot(2,1,1);
    axObjs = fig3.Children;
    dataObjs = axObjs(2).Children;
    time_min_3 = dataObjs(1).XData;
    meanMDL_3 = dataObjs(1).YData - 2000;   % Substract actual distance so the measurement error remains

    % Extract data from second subplot
    subplot(2,1,2);
    axObjs = fig3.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_3 = dataObjs(1).YData;

    %% Data from 25-07-2021 -- 2500
    % Load figure data
    fig4 = openfig('Mean Depth against Time 10 hour run minutes version 25-07-2021.fig');

    % Extract data from first subplot
    subplot(2,1,1);
    axObjs = fig4.Children;
    dataObjs = axObjs(2).Children;
    time_min_4 = dataObjs(1).XData;
    meanMDL_4 = dataObjs(1).YData - 2500;   % Substract actual distance so the measurement error remains

    % Extract data from second subplot
    subplot(2,1,2);
    axObjs = fig4.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_4 = dataObjs(1).YData;

    %% Data from 23-07-2021 -- 3000
    % Load figure data
    fig5 = openfig('Mean Depth against Time 10 hour run minutes version 23-07-2021.fig');

    % Extract data from first subplot
    subplot(2,1,1);
    axObjs = fig5.Children;
    dataObjs = axObjs(2).Children;
    time_min_5 = dataObjs(1).XData;
    meanMDL_5 = dataObjs(1).YData - 3000;   % Substract actual distance so the measurement error remains

    % Extract data from second subplot
    subplot(2,1,2);
    axObjs = fig5.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_5 = dataObjs(1).YData;
    
    %% Data from 08-08-2021 -- 1500
    % Load figure data
    fig6 = openfig('Mean Depth against Time 10 hour run minutes version 08-08-2021.fig');

    % Extract data from first subplot
    subplot(2,1,1);
    axObjs = fig6.Children;
    dataObjs = axObjs(2).Children;
    time_min_6 = dataObjs(1).XData;
    meanMDL_6 = dataObjs(1).YData - 1500;   % Substract actual distance so the measurement error remains

    % Extract data from second subplot
    subplot(2,1,2);
    axObjs = fig6.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_6 = dataObjs(1).YData;
    
    %% close all
    close all;      % "openfig" opens all figures, which is not necessary and can therefore be closed.
end
