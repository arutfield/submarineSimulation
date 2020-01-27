clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;

resolution = 10;
mapSize = [2000 2000];
disp('Generating list of obstacles');
%listOfObstacles = generateObstacles(mapSize, norm(submarineDimensions)*2, resolution, true);
load obstacleData;
disp('Made list of obstacles');
fullMap = generateMap(listOfObstacles, mapSize, false, resolution);
[success, knownMap]=mapEnvironment(fullMap, resolution);