% script to run to estimate time to map ocean and loch ness

% map 3D area 1 obstacle 0.125 km^3
clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;


% map 3D area 1 obstacle 0.027 km^3
resolution = 20;
mapSize3D = [300 300 300];
testSizeVolume(1) = prod(mapSize3D);
submarineDimensions = [submarineLength submarineHeight submarineWidth];
%disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D(:,1), mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D, totalTime(1)]=mapEnvironment(fullMap3D, resolution);

% map 3D area (not cube) 0.054 km^3
resolution = 20;
mapSize3D = [600 300 300];
testSizeVolume(2) = prod(mapSize3D);
submarineDimensions = [submarineLength submarineHeight submarineWidth];
%disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D(:,2), mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D, totalTime(2)]=mapEnvironment(fullMap3D, resolution);

resolution = 20;
mapSize3D = [500 500 500];
testSizeVolume(3) = prod(mapSize3D);
submarineDimensions = [submarineLength submarineHeight submarineWidth];
%disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D(:,1), mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D, totalTime(3)]=mapEnvironment(fullMap3D, resolution);

% results
% ln approximation: x=volume (m^3), y=time
a=-8376.5507
b=491.35038


% loch ness is 7.4 cubic km 
estimatedLochNessSize = 7.4 * 1000^3;
lochNessTime = a+b*log(estimatedLochNessSize);
disp(['Estimate time to map Loch Ness: ', num2str(lochNessTime)]);

% ocean is 1.35 billion cubic km
estimatedOceanSize = 1.35*10^9*1000^3;
oceanTime = a+b*log(estimatedOceanSize);
disp(['Estimate time to map ocean: ', num2str(oceanTime)]);
