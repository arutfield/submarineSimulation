pkg load geometry;
clear; close all;
resolution = 2;
loadSubmarineSpecifications;
testPt = [1 2 3]';
testPt2 = [-3 -2 2]';
dimensions2D = [5 6];
obstacles=[1.0 -1.0 -1.0; 0.5 -0.5 1.5; 0.0 0.0 0.0];
obstacles3D = [0.5  0.5  1.5  0.5 -1.5  1.5  1.5  1.5  ;...
               1    0   -1    0   -1   -1    0    0;...
              -4.5 -2.5 -4.5 -3.5 -1.5 -3.5 -4.5 -0.5];
[map, figureHandle2DMap] = generateMap(obstacles, dimensions2D, true, resolution);
[map3D, figureHandle3DMap] = generateMap(obstacles3D, [4 5 6], true, resolution);
testPtMap=convertCoordinateToMap(testPt, map3D, resolution);
testPt2Map=convertCoordinateToMap(testPt2, map3D, resolution);

testPtReturn=convertMapToCoordinate(testPtMap, map3D, resolution);
testPt2Return=convertMapToCoordinate(testPt2Map, map3D, resolution);
if (isequal(testPtReturn, testPt) && isequal(testPt2Return, testPt2))
  disp("pass pt conversion");
else
  disp(["failed pt conversion: , ", num2str(testPt'), ", ", num2str(testPtReturn')]);
  disp(["failed pt2 conversion: , ", num2str(testPt2'), ", ", num2str(testPt2Return')]);
endif

startPoint1=[-1 0.5 0]';
finishPoint1=[2 2.5 0]';
wavePath1 = generateWaveformPath(startPoint1, finishPoint1, map, resolution);

startPoint2=[-2 2.5 0]';
finishPoint2=[2 -2.5 0]'
wavePath2 = generateWaveformPath(startPoint2, finishPoint2, map, resolution);
 
startPoint1_3d = [-1.5 1 -0.5]';
finishPoint1_3d = [1.5 2 -3.5]';
wavePath1_3d = generateWaveformPath(startPoint1_3d, finishPoint1_3d, map3D, resolution);

startPoint2_3d = [1.5 -2 -5.5]';
finishPoint2_3d = [-1.5 2 -0.5]';
wavePath2_3d = generateWaveformPath(startPoint2_3d, finishPoint2_3d, map3D, resolution);

% plot wavePath 2d
wavePath1Coordinates = zeros(size(wavePath1));
wavePath2Coordinates = zeros(size(wavePath2));
for k=1:size(wavePath1,2)
  wavePath1Coordinates(:,k)=convertMapToCoordinate(wavePath1(:,k), map, resolution);
endfor
for k=1:size(wavePath2,2)
  wavePath2Coordinates(:,k)=convertMapToCoordinate(wavePath2(:,k), map, resolution);
endfor
figure(figureHandle2DMap);
hold on;
plot3(wavePath2Coordinates(1,:), wavePath2Coordinates(2,:), wavePath2Coordinates(3,:), 'r');

if (length(wavePath1Coordinates) == 0)
  disp("wave path 1 has no path");
else
  plotMap(map, obstacles, dimensions2D, resolution, true)
  hold on;
  plot3(wavePath1Coordinates(1,:), wavePath1Coordinates(2,:), wavePath1Coordinates(3,:), 'b');  
  wayPoints = generateWayPoints(wavePath1Coordinates, resolution);
  scatter3(wayPoints(1,:), wayPoints(2,:), wayPoints(3,:));
endif
if (length(wavePath2Coordinates) == 0)
  disp("wave path 2 has no path");
else
  wayPoints2 = generateWayPoints(wavePath2Coordinates, resolution);
  scatter3(wayPoints2(1,:), wayPoints2(2,:), wayPoints2(3,:));
endif


% plot wavePath 3d
wavePath1_3dCoordinates = zeros(size(wavePath1_3d));
wavePath2_3dCoordinates = zeros(size(wavePath2_3d));
for k=1:size(wavePath1_3d,2)
  wavePath1_3dCoordinates(:,k)=convertMapToCoordinate(wavePath1_3d(:,k), map3D, resolution);
endfor
for k=1:size(wavePath2_3d,2)
  wavePath2_3dCoordinates(:,k)=convertMapToCoordinate(wavePath2_3d(:,k), map3D, resolution);
endfor
figure(figureHandle3DMap);
hold on;
plot3(wavePath1_3dCoordinates(1,:), wavePath1_3dCoordinates(2,:), wavePath1_3dCoordinates(3,:), 'g');
plot3(wavePath2_3dCoordinates(1,:), wavePath2_3dCoordinates(2,:), wavePath2_3dCoordinates(3,:), 'r');

wayPoints_3d = generateWayPoints(wavePath1_3dCoordinates, resolution);
scatter3(wayPoints_3d(1,:), wayPoints_3d(2,:), wayPoints_3d(3,:));
wayPoints2_3d = generateWayPoints(wavePath2_3dCoordinates, resolution);
scatter3(wayPoints2_3d(1,:), wayPoints2_3d(2,:), wayPoints2_3d(3,:));

% test trajectory generator
startTraj = [-1 0 2]';
endTraj = [1 2 3]';
[trajectoryNoMaxSpeed, time, trajectoryProportionsNoMaxSpeed]=generateTrapezoidalTrajectory(startTraj, endTraj, 100, 5, 2);
for k=1:size(trajectoryNoMaxSpeed,2)
  distancesNoMax(k) = norm(trajectoryNoMaxSpeed(:,k)-startTraj);
endfor
frequency=100;
speedsNoMax=diff(distancesNoMax)*frequency;
accelsNoMax=diff(speedsNoMax)*frequency;
figure;
plot(time,distancesNoMax);
hold on;
plot(time(2:end), speedsNoMax);
plot(time(3:end),accelsNoMax);
legend('distances', 'speeds', 'accel', 'Location', 'southwest');
figure;
plot(time, trajectoryNoMaxSpeed');
legend('x', 'y', 'z', 'Location', 'southeast');

[trajectoryWithMaxSpeed, time_max, trajectoryProportionsMaxSpeed]=generateTrapezoidalTrajectory(startTraj, endTraj, 2, 5, 7);
for k=1:size(trajectoryWithMaxSpeed,2)
  distancesMax(k) = norm(trajectoryWithMaxSpeed(:,k)-startTraj);
endfor
speedsMax=diff(distancesMax)*frequency;
accelsMax=diff(speedsMax)*frequency;
figure;
plot(time_max,distancesMax);
hold on;
plot(time_max(2:end), speedsMax);
plot(time_max(3:end),accelsMax);
legend('distances', 'speeds', 'accel', 'Location', 'southwest');
figure;
plot(time_max, trajectoryWithMaxSpeed');
legend('x', 'y', 'z', 'Location', 'southeast');

% see sub move
figure(figureHandle2DMap, 'position', [500 500, 1000, 1000]);
hold on;
for w=1:size(wayPoints2,2)-1
  trajectory2D=generateTrapezoidalTrajectory(wayPoints2(:,w), wayPoints2(:,w+1), 1, 0.2, 0.2);
  x=trajectory2D(1,:);
  y=trajectory2D(2,:);
  z=trajectory2D(3,:);
  for k=1:size(trajectory2D,2)
    h = plot3(trajectory2D(1,k), trajectory2D(2,k), trajectory2D(3,k), 'o-k');
    pause(0.01);
    if (k<size(trajectory2D,2) || w<size(wayPoints2,2)-1)
      set(h, 'Visible', 'off');
    endif
  endfor
endfor


% see sub move
figure(figureHandle3DMap, 'position', [500 500, 1000, 1000]);
hold on;
for w=1:size(wayPoints2_3d,2)-1
  trajectory3D=generateTrapezoidalTrajectory(wayPoints2_3d(:,w), wayPoints2_3d(:,w+1), 1, 0.2, 0.3);
  x=trajectory3D(1,:);
  y=trajectory3D(2,:);
  z=trajectory3D(3,:);
  for k=1:size(trajectory3D,2)
    h = plot3(trajectory3D(1,k), trajectory3D(2,k), trajectory3D(3,k), 'o-k');
    pause(0.01);
    if (k<size(trajectory3D,2) || w<size(wayPoints2_3d,2)-1)
      set(h, 'Visible', 'off');
    endif
  endfor
endfor
