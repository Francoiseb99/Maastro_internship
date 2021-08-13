function [meanMDL_1,meanMDL_2,meanMDL_3,meanMDL_4,meanMDL_5,time_min_1] = ExtractData()
    %% Data from 17-07-2021 -- 1500
    % load figure data
    fig1 = openfig('Mean Depth against Time 10 hour run minutes version 17-07-2021.fig');

    % extract data from first subplot
    subplot(2,1,1);
    axObjs = fig1.Children;
    dataObjs = axObjs(2).Children;
    time_min_1 = dataObjs(1).XData;
    meanMDL_1 = dataObjs(1).YData - 1500;

    % extract data from second subplot
    subplot(2,1,2);
    axObjs = fig1.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_1 = dataObjs(1).YData;

    %% Data from 18-07-2021 -- 1500
    % load figure data
    fig2 = openfig('Mean Depth against Time 10 hour run minutes version 18-07-2021.fig');

    % extract data from first subplot
    subplot(2,1,1);
    axObjs = fig2.Children;
    dataObjs = axObjs(2).Children;
    time_min_2 = dataObjs(1).XData;
    meanMDL_2 = dataObjs(1).YData - 1500;

    % extract data from second subplot
    subplot(2,1,2);
    axObjs = fig2.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_2 = dataObjs(1).YData;

    %% Data from 24-07-2021 -- 2000
    % load figure data
    fig3 = openfig('Mean Depth against Time 10 hour run minutes version 24-07-2021.fig');

    % extract data from first subplot
    subplot(2,1,1);
    axObjs = fig3.Children;
    dataObjs = axObjs(2).Children;
    time_min_3 = dataObjs(1).XData;
    meanMDL_3 = dataObjs(1).YData - 2000;

    % extract data from second subplot
    subplot(2,1,2);
    axObjs = fig3.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_3 = dataObjs(1).YData;

    %% Data from 25-07-2021 -- 2500
    % load figure data
    fig4 = openfig('Mean Depth against Time 10 hour run minutes version 25-07-2021.fig');

    % extract data from first subplot
    subplot(2,1,1);
    axObjs = fig4.Children;
    dataObjs = axObjs(2).Children;
    time_min_4 = dataObjs(1).XData;
    meanMDL_4 = dataObjs(1).YData - 2500;

    % extract data from second subplot
    subplot(2,1,2);
    axObjs = fig4.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_4 = dataObjs(1).YData;

    %% Data from 23-07-2021 -- 3000
    % load figure data
    fig5 = openfig('Mean Depth against Time 10 hour run minutes version 23-07-2021.fig');

    % extract data from first subplot
    subplot(2,1,1);
    axObjs = fig5.Children;
    dataObjs = axObjs(2).Children;
    time_min_5 = dataObjs(1).XData;
    meanMDL_5 = dataObjs(1).YData - 3000;

    % extract data from second subplot
    subplot(2,1,2);
    axObjs = fig5.Children;
    dataObjs = axObjs(1).Children;
    stdMDL_5 = dataObjs(1).YData;
    
    %% close all
    close all;
end
