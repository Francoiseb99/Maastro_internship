%% Load data horizontal 1
horizontal1 = load('Orientation_horizontal_run1.mat');
time_sec1 = horizontal1.time_sec;
pitch_list1 = horizontal1.pitch_list;
roll_list1 = horizontal1.roll_list;
yaw_list1 = horizontal1.yaw_list;

%% Load data horizontal 2
horizontal2 = load('Orientation_horizontal_run2.mat');
time_sec2 = horizontal2.time_sec;
pitch_list2 = horizontal2.pitch_list;
roll_list2 = horizontal2.roll_list;
yaw_list2 = horizontal2.yaw_list;

%% Load data vertical 1
vertical1 = load('Orientation_vertical_run1.mat');
time_sec3 = vertical1.time_sec;
pitch_list3 = vertical1.pitch_list;
roll_list3 = vertical1.roll_list;
yaw_list3 = vertical1.yaw_list;

%% Plot figure
f10 = figure;
p1_1 = plot(time_sec1,pitch_list1,'b-'); 
hold on;
p1_2 = plot(time_sec1,yaw_list1,'r-'); 
hold on;
p1_3 = plot(time_sec1,roll_list1,'c-'); 
hold on;
p2_1 = plot(time_sec2,pitch_list2,'b--'); 
hold on;
p2_2 = plot(time_sec2,yaw_list2,'r--'); 
hold on;
p2_3 = plot(time_sec2,roll_list2,'c--'); 
hold on;
p3_1 = plot(time_sec3,pitch_list3,'b:'); 
hold on;
p3_2 = plot(time_sec3,yaw_list3,'r:'); 
hold on;
p3_3 = plot(time_sec3,roll_list3,'c:');
hold off;
title('Gyroscope Output against Time');
xlabel('Frame');
ylabel('Gyroscope output');
xlim([0 max(time_sec)])
grid on;
lgd = legend([p1_1,p1_2,p1_3,p2_1,p2_2,p2_3, p3_1,p3_2,p3_3], ...
    {'Pitch, horizontal run 1','Yaw, horizontal run 1','Roll, horizontal run 1', ...
    'Pitch, horizontal run 2','Yaw, horizontal run 2','Roll, horizontal run 2', ...
    'Pitch, vertical run 1','Yaw, vertical run 1','Roll, vertical run 1'},'Location','northwest');
