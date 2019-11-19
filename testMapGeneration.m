clear; clc; close all;
resolution = 5;
loadSubmarineSpecifications;


obstacles = [-5 2 3 -6 -5  5  2  2 1 5 5 6 7 -1  3 4 -3 -2 -3 5 -4  7 -6  4 -4 1 -3  2;...
             -1 6 6  6 -5 -6 -5 -5 5 2 4 2 3 -4 -1 3 -1  4  7 3 -3 -6 -5 -2 -3 6 -4 -7;...
              0 0 0  0  0  0  0  0 0 0 0 0 0  0  0 0  0  0  0 0  0  0  0  0  0 0  0  0];
dimensions2D = [19 17];
[map, figureHandle2DMap] = generateMap(obstacles, dimensions2D, false, resolution);
%initialUnknownMap = generateUnknownMap(map, [0 0 0]', [4 2 0], 5, resolution);
%figureHandle = plotKnownMap(initialUnknownMap, resolution);


% big map for timing
dimensions2DBig = [500 600];
[bigMap, figureHandle2DBigMap] = generateMap(obstacles, dimensions2DBig, false, resolution);
initialUnknownBigMap = generateUnknownMap(bigMap, [-100 0 0]', [submarineLength submarineWidth 0], submarineLightDistance, resolution);
bigFigureHandle = plotKnownMap(initialUnknownBigMap, resolution);
