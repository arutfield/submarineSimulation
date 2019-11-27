pkg load geometry;
clear; clc; close all;
resolution = 0.5;
loadSubmarineSpecifications;

obstacles = [-5 2 3 -6 -5  5  2  2 1 5 5 6 7 -1  3 4 -3 -2 -3 5 -4  7 -6  4 -4 1 -3  2;...
             -1 6 6  6 -5 -6 -5 -5 5 2 4 2 3 -4 -1 3 -1  4  7 3 -3 -6 -5 -2 -3 6 -4 -7;...
              0 0 0  0  0  0  0  0 0 0 0 0 0  0  0 0  0  0  0 0  0  0  0  0  0 0  0  0];
dimensions2D = [19 17];
submarineLocation = [0 0 0]';
submarineDimensions = [4 2 0];
[map, figureHandle2DMap] = generateMap(obstacles, dimensions2D, false, resolution);
initialUnknownMap = generateUnknownMap(map, submarineLocation, submarineDimensions, 5, resolution);
[centroid, frontierMap] = findFrontierCentroid(initialUnknownMap);
figureHandle = plotFrontierMap(initialUnknownMap, frontierMap, centroid, resolution);
expandedMap = generateExpandedObstaclesMap(initialUnknownMap, submarineLocation, submarineDimensions, resolution);
plotKnownMap(expandedMap, resolution);

resolution = 0.5;
obstacles3D = [0.5  2.5  1.5  0.5 -1.5  1.5  1.5  1.5  ;...
               1    0   -1    0   -1   -1    0    0;...
              -2.5 -2.5 -2.5 -3.5 -2.5 -3.5 -2.5 -2.5];
submarineLocation3D = [0 0 -1]';
submarineDimensions3D = [4 2 1];
[map3D, figureHandle3DMap] = generateMap(obstacles3D, [6 7 8], false, resolution);
initialUnknownMap3D = generateUnknownMap(map3D, submarineLocation3D, submarineDimensions3D, 5, resolution);
[centroid3D, frontierMap3D] = findFrontierCentroid(initialUnknownMap3D);
figureHandle3D = plotFrontierMap(initialUnknownMap3D, frontierMap3D, centroid3D, resolution);
expandedMap3D = generateExpandedObstaclesMap(initialUnknownMap3D, submarineLocation3D, submarineDimensions3D, resolution);
plotKnownMap(expandedMap3D, resolution);