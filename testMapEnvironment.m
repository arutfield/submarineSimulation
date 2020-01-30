clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;

resolution = 10;
mapSize = [1000 1000];
submarineDimensions = [submarineLength submarineHeight submarineWidth];
disp('Generating list of obstacles');
%listOfObstacles = generateObstacles(mapSize, norm(submarineDimensions)*2, resolution, true);
load obstacleData;
disp('Made list of obstacles');
fullMap = generateMap(listOfObstacles, mapSize, false, resolution);
disp('testMapEnvironment-generated map');
[success, knownMap, finalPosition]=mapEnvironment(fullMap, resolution);