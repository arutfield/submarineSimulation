% create empty map
clear; clc; close all;
dimensions2D = [25 25];
resolution = 0.5;
startPoint2D = zeros(3,1);
finishPoint2D = [-5 5 0];
fullMap2D = generateMap([3 3 0]', dimensions2D, true, resolution);
subSize2D = [4 2 0];
flashlightRange = 5;
unknownMap = generateUnknownMap(fullMap2D, startPoint2D, subSize2D, flashlightRange, resolution);
unknownMap2DHandle = plotKnownMap(unknownMap, resolution);
expandedObstaclesMap = generateExpandedObstaclesMap(unknownMap, startPoint2D, subSize2D, resolution);
plotKnownMap(expandedObstaclesMap, resolution);

wavePath2DMap = generateWaveformPath(startPoint2D, finishPoint2D, expandedObstaclesMap, resolution);

[figureHandle2D, totalTime2D]=animateWaveformMovement(unknownMap, fullMap2D, wavePath2DMap, subSize2D, flashlightRange, resolution, 13, 8, 10);