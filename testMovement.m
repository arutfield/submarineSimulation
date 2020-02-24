% create empty map
% test having a sub generate a path between two points and shows it moving
% across the map

clear; clc; close all;
loadSubmarineSpecifications;
% 2D sub movement
dimensions2D = [25 25];
resolution = 0.5;
startPoint2D = zeros(3,1);
finishPoint2D = [5 5 0];
fullMap2D = generateMap([3 3 0]', dimensions2D, true, resolution);
subSize2D = [4 2 0];
flashlightRange = 5;
unknownMap = generateUnknownMap(fullMap2D, startPoint2D, subSize2D, flashlightRange, resolution);
[unknownMap2DHandle, submarineHandles] = plotKnownMap(unknownMap, resolution, []);
expandedObstaclesMap = generateExpandedObstaclesMap(unknownMap, startPoint2D, subSize2D, resolution);
plotKnownMap(expandedObstaclesMap, resolution);

wavePath2DMap = generateWavefrontPath(startPoint2D, finishPoint2D, expandedObstaclesMap, resolution);
%a=figure;
figure(unknownMap2DHandle);
[finalMap, expandedObstaclesMap, figureHandle2D, totalTime2D]=...
animateWavefrontMovement(unknownMap, fullMap2D, expandedObstaclesMap, wavePath2DMap, subSize2D, flashlightRange, resolution, 13, 8, 10, unknownMap2DHandle, submarineHandles);
                                                                                 

% 3d sub movement
clear; close all;
disp('Start 3d test');
pkg load geometry;
dimensions3D = [25 25 25];
resolution = 2;
startPoint3D = [0 0 -1]';
finishPoint3D = [8 -8 -22]';
fullMap3D = generateMap([3 3 -4]', dimensions3D, true, resolution);
subSize3D = [4 2 4]';
flashlightRange = 5;
unknownMap3D = generateUnknownMap(fullMap3D, startPoint3D, subSize3D, flashlightRange, resolution);
[unknownMap3DHandle, submarineHandles3D] = plotKnownMap(unknownMap3D, resolution, []);
expandedObstaclesMap3D = generateExpandedObstaclesMap(unknownMap3D, startPoint3D, subSize3D, resolution);

wavePath3DMap = generateWavefrontPath(startPoint3D, finishPoint3D, expandedObstaclesMap3D, resolution);
figure(unknownMap3DHandle);
[finalMap3D, expandedObstaclesMap3D, figureHandle3D, totalTime3D, finalSubPosition3D]=animateWavefrontMovement(unknownMap3D, fullMap3D, expandedObstaclesMap3D, wavePath3DMap, subSize3D, flashlightRange, resolution, 13, 8, 10, unknownMap3DHandle, submarineHandles3D);


%%
% 3d with hidden obstacle that can only be found mid-movement
clear; close all;
dimensionsObstacle = [20 25 25];
resolution = 2;
startPointObstacle = [0 0 -1]';
finishPointObstacle = [6 -8 -18]';

fullMapObstacle = generateMap([5.5 -5.5 -7.5]', dimensionsObstacle, true, resolution);
subSizeObstacle = [3 1 2]';
flashlightRange = 5;
unknownMapObstacle = generateUnknownMap(fullMapObstacle, startPointObstacle, subSizeObstacle, flashlightRange, resolution);
[unknownMapObstacleHandle, subHandles] = plotKnownMap(unknownMapObstacle, resolution, []);
expandedObstaclesMapObstacle = generateExpandedObstaclesMap(unknownMapObstacle, startPointObstacle, subSizeObstacle, resolution);
success = false;
totalTime=0;
figure(unknownMapObstacleHandle);
while(!success)
  wavePathObstacleMap = generateWavefrontPath(startPointObstacle, finishPointObstacle, expandedObstaclesMapObstacle, resolution);
  disp(['wavepath: ']);
  disp(num2str(wavePathObstacleMap));
  [finalMapObstacle, expandedObstaclesMapObstacle, figureHandleObstacle, totalTimeObstacle, finalSubPositionObstacle, subHandles, success]=animateWavefrontMovement(unknownMapObstacle, fullMapObstacle, expandedObstaclesMapObstacle, wavePathObstacleMap, subSizeObstacle, flashlightRange, resolution, 13, 8, 10, unknownMapObstacleHandle, subHandles);
  startPointObstacle = finalSubPositionObstacle;
  totalTime = totalTime + totalTimeObstacle;
endwhile