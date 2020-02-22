% script to run to estimate time to map ocean and loch ness

% map 3D area 1 obstacle 0.125 km^3
clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;


% map 3D area 1 obstacle 0.027 km^3
resolution = 20;
mapSize3D = [300 300 300];
testSize2Volume = prod(mapSize3D);
submarineDimensions = [submarineLength submarineHeight submarineWidth];
%disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D(:,1), mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D, totalTime(2)]=mapEnvironment(fullMap3D, resolution);

% map 3D area (not cube) 0.054 km^3
resolution = 20;
mapSize3D = [600 300 300];
testSize2Volume = prod(mapSize3D);
submarineDimensions = [submarineLength submarineHeight submarineWidth];
%disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D(:,2), mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D, totalTime(3)]=mapEnvironment(fullMap3D, resolution);

resolution = 20;
mapSize3D = [500 500 500];
testSize1Volume = prod(mapSize3D);
submarineDimensions = [submarineLength submarineHeight submarineWidth];
%disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D(:,1), mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D, totalTime(1)]=mapEnvironment(fullMap3D, resolution);


% loch ness is 7.4 cubic km 
estimatedLochNessSize = 7.4;
% ocean is 1.35 billion cubic km
estimatedOceanSize = 1.35*10^9*1000^3;