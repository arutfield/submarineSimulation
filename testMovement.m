% create empty map
clear; clc; close all;
dimensions2D = [25 25];
resolution = 0.5;
startPoint2D = zeros(3,1);
finishPoint2D = [5 5 0];
fullMap2D = generateMap([3 3 0]', dimensions2D, true, resolution);
subSize2D = [4 2 0];
flashlightRange = 5;
unknownMap = generateUnknownMap(fullMap2D, startPoint2D, subSize2D, flashlightRange, resolution);
unknownMap2DHandle = plotKnownMap(unknownMap, resolution, []);
expandedObstaclesMap = generateExpandedObstaclesMap(unknownMap, startPoint2D, subSize2D, resolution);
plotKnownMap(expandedObstaclesMap, resolution);

wavePath2DMap = generateWaveformPath(startPoint2D, finishPoint2D, expandedObstaclesMap, resolution);

[finalMap, figureHandle2D, totalTime2D]=animateWaveformMovement(unknownMap, fullMap2D, wavePath2DMap, subSize2D, flashlightRange, resolution, 13, 8, 10);


% 3d
pkg load geometry;
dimensions3D = [25 25 25];
resolution = 2;
startPoint3D = [0 0 -1]';
finishPoint3D = [8 -8 -22]';
fullMap3D = generateMap([3 3 -4]', dimensions3D, true, resolution);
subSize3D = [4 2 4]';
flashlightRange = 5;
unknownMap3D = generateUnknownMap(fullMap3D, startPoint3D, subSize3D, flashlightRange, resolution);
unknownMap3DHandle = plotKnownMap(unknownMap3D, resolution, []);
expandedObstaclesMap3D = generateExpandedObstaclesMap(unknownMap3D, startPoint3D, subSize3D, resolution);
%plotKnownMap(expandedObstaclesMap3D, resolution);

wavePath3DMap = generateWaveformPath(startPoint3D, finishPoint3D, expandedObstaclesMap3D, resolution);

[finalMap3D, figureHandle3D, totalTime3D, finalSubPosition3D]=animateWaveformMovement(unknownMap3D, fullMap3D, wavePath3DMap, subSize3D, flashlightRange, resolution, 13, 8, 10);