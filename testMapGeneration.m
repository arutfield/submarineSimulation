% test that maps get generated correctly

% create a 2D map
pkg load geometry;
clear; clc; close all;
resolution = 0.5;
loadSubmarineSpecifications;


obstacles = [-5 2 3 -6 -5  5  2  2 1 5 5 6 7 -1  3 4 -3 -2 -3 5 -4  7 -6  4 -4 1 -3  2;...
             -1 6 6  6 -5 -6 -5 -5 5 2 4 2 3 -4 -1 3 -1  4  7 3 -3 -6 -5 -2 -3 6 -4 -7;...
              0 0 0  0  0  0  0  0 0 0 0 0 0  0  0 0  0  0  0 0  0  0  0  0  0 0  0  0];
dimensions2D = [19 17];
[map, figureHandle2DMap] = generateMap(obstacles, dimensions2D, false, resolution);
initialUnknownMap = generateUnknownMap(map, [0 0 0]', [4 2 0], 5, resolution);
figureHandle = plotKnownMap(initialUnknownMap, resolution, []);
unknownMapUpdated = updateMap(map, initialUnknownMap, [1.5 2 0]', [4 2 0], 5, resolution);
figureHandleUpdated = plotKnownMap(unknownMapUpdated, resolution, []);



resolution = 5;
% big map for timing test and large resolution
dimensions2DBig = [500 600];
[bigMap, figureHandle2DBigMap] = generateMap(obstacles, dimensions2DBig, false, resolution);
initialUnknownBigMap = generateUnknownMap(bigMap, [-100 0 0]', [submarineLength submarineWidth 0], submarineLightDistance, resolution);
bigFigureHandle = plotKnownMap(initialUnknownBigMap, resolution);

% test creating a 3D map with a small resolution
resolution = 0.5;
obstacles3D = [0.5  2.5  1.5  0.5 -1.5  1.5  1.5  1.5  ;...
               1    0   -1    0   -1   -1    0    0;...
              -2.5 -2.5 -2.5 -3.5 -2.5 -3.5 -2.5 -2.5];
submarineDimensions3D = [4 2 1];
[map3D, figureHandle3DMap] = generateMap(obstacles3D, [6 7 8], false, resolution);
initialUnknownMap3D = generateUnknownMap(map3D, [0 0 -1]', submarineDimensions3D, 5, resolution);
figureHandle3D = plotKnownMap(initialUnknownMap3D, resolution, []);
unknownMapUpdated3D = updateMap(map3D, initialUnknownMap3D, [-1 2 -4]', submarineDimensions3D, 5, resolution);
figureHandleUpdated3D = plotKnownMap(unknownMapUpdated3D, resolution, []);
