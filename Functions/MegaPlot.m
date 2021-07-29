%% Data from 17-07-2021 -- 1500

fig1 = openfig('Mean Depth against Time 10 hour run minutes version 17-07-2021.fig');

subplot(2,1,1);
axObjs = fig1.Children;
dataObjs = axObjs(2).Children;
time_min_1 = dataObjs(1).XData;
meanMDL_1 = dataObjs(1).YData - 1500;

subplot(2,1,2);
axObjs = fig1.Children;
dataObjs = axObjs(1).Children;
stdMDL_1 = dataObjs(1).YData;

%% Data from 18-07-2021 -- 1500
fig2 = openfig('Mean Depth against Time 10 hour run minutes version 18-07-2021.fig');

subplot(2,1,1);
axObjs = fig2.Children;
dataObjs = axObjs(2).Children;
time_min_2 = dataObjs(1).XData;
meanMDL_2 = dataObjs(1).YData - 1500;

subplot(2,1,2);
axObjs = fig2.Children;
dataObjs = axObjs(1).Children;
stdMDL_2 = dataObjs(1).YData;

%% Data from 24-07-2021 -- 2000
fig3 = openfig('Mean Depth against Time 10 hour run minutes version 24-07-2021.fig');

subplot(2,1,1);
axObjs = fig3.Children;
dataObjs = axObjs(2).Children;
time_min_3 = dataObjs(1).XData;
meanMDL_3 = dataObjs(1).YData - 2000;

subplot(2,1,2);
axObjs = fig3.Children;
dataObjs = axObjs(1).Children;
stdMDL_3 = dataObjs(1).YData;

%% Data from 25-07-2021 -- 2500
fig4 = openfig('Mean Depth against Time 10 hour run minutes version 25-07-2021.fig');

subplot(2,1,1);
axObjs = fig4.Children;
dataObjs = axObjs(2).Children;
time_min_4 = dataObjs(1).XData;
meanMDL_4 = dataObjs(1).YData - 2500;

subplot(2,1,2);
axObjs = fig4.Children;
dataObjs = axObjs(1).Children;
stdMDL_4 = dataObjs(1).YData;

%% Data from 23-07-2021 -- 3000
fig5 = openfig('Mean Depth against Time 10 hour run minutes version 23-07-2021.fig');

subplot(2,1,1);
axObjs = fig5.Children;
dataObjs = axObjs(2).Children;
time_min_5 = dataObjs(1).XData;
meanMDL_5 = dataObjs(1).YData - 3000;

subplot(2,1,2);
axObjs = fig5.Children;
dataObjs = axObjs(1).Children;
stdMDL_5 = dataObjs(1).YData;

%% Close figures
close all;

%% Plot figure
f1=figure;

subplot(3,4,[1 2 3 5 6 7]);

p1_1 = plot(time_min_1,meanMDL_1);
hold on;
p1_2 = plot(time_min_2,meanMDL_2);
hold on;
p1_3 = plot(time_min_3,meanMDL_3);
hold on;
p1_4 = plot(time_min_4,meanMDL_4);
hold on;
p1_5 = plot(time_min_5,meanMDL_5);
hold on;

ax1 = f1.CurrentAxes;
xlim([0 max(time_min_1)])
title(ax1, 'Mean Depth against Time (normalized)');
xlabel(ax1, 'Time (minutes)');
ylabel(ax1, 'Depth (mm)');
hold off;

lgd = legend([p1_1,p1_2,p1_3,p1_4,p1_5],{'1500 mm','1500 mm','2000 mm','2500 mm','3000 mm'},'Location','southeast');
%legend([p1_1,p1_2,p1_3,p1_4,p1_5],{'1500 mm','1500 mm','2000 mm','2500 mm','3000 mm'},'Location','southeast')

newPosition = [0.67 0.4 0.2 0.2];
newUnits = 'normalized';
set(lgd,'Position', newPosition,'Units', newUnits);
title(lgd,'Actual distances','FontSize',12)

subplot(3,4,[9 10 11]);

p2_1 = plot(time_min_1,stdMDL_1);
hold on;
p2_2 = plot(time_min_2,stdMDL_2);
hold on;
p2_3 = plot(time_min_3,stdMDL_3);
hold on;
p2_4 = plot(time_min_4,stdMDL_4);
hold on;
p2_5 = plot(time_min_5,stdMDL_5);
hold on;



ax1 = f1.CurrentAxes;
xlim([0 max(time_min_1)])
title(ax1, 'Std Depth against Time');
xlabel(ax1, 'Time (minutes)');
ylabel(ax1, 'Std depth (mm)'); 
hold off;

%% plot seperate figures (1)
f2=figure;

p1_1 = plot(time_min_1,meanMDL_1);
hold on;
p1_2 = plot(time_min_2,meanMDL_2);
hold on;
p1_3 = plot(time_min_3,meanMDL_3);
hold on;
p1_4 = plot(time_min_4,meanMDL_4);
hold on;
p1_5 = plot(time_min_5,meanMDL_5);
hold on;

ax2 = f2.CurrentAxes;
xlim([0 max(time_min_1)])
title(ax2, 'Mean Depth against Time (normalized)');
xlabel(ax2, 'Time (minutes)');
ylabel(ax2, 'Depth (mm)');
hold off;

lgd = legend([p1_1,p1_2,p1_3,p1_4,p1_5],{'1500 mm','1500 mm','2000 mm','2500 mm','3000 mm'},'Location','southeast');

%% plot seperate figures (2)

f3=figure;

p2_1 = plot(time_min_1,stdMDL_1);
hold on;
p2_2 = plot(time_min_2,stdMDL_2);
hold on;
p2_3 = plot(time_min_3,stdMDL_3);
hold on;
p2_4 = plot(time_min_4,stdMDL_4);
hold on;
p2_5 = plot(time_min_5,stdMDL_5);
hold on;

ax3 = f3.CurrentAxes;
xlim([0 max(time_min_1)])
title(ax3, 'Std Depth against Time');
xlabel(ax3, 'Time (minutes)');
ylabel(ax3, 'Std depth (mm)'); 
hold off;
lgd = legend([p1_1,p1_2,p1_3,p1_4,p1_5],{'1500 mm','1500 mm','2000 mm','2500 mm','3000 mm'},'Location','southeast');
