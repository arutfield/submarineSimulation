clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;

resolution = 10;
mapSize = [1000 1000];
submarineDimensions = [submarineLength submarineHeight];
disp('Generating list of obstacles');
%listOfObstacles = generateObstacles(mapSize, norm(submarineDimensions)*2, resolution, true);
load obstacleData;
disp('Made list of obstacles');
fullMap = generateMap(listOfObstacles, mapSize, false, resolution);
disp('testMapEnvironment-generated map');
[success, knownMap, finalPosition]=mapEnvironment(fullMap, resolution);

clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;
resolution = 20;
mapSize3D = [500 500 500];
submarineDimensions = [submarineLength submarineHeight submarineWidth];
disp('Generating list of obstacles 3D');
%listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
%save obstacleData3D;
load obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D, mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D]=mapEnvironment(fullMap3D, resolution);