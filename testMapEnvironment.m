% test mapping the environment (full routine)

% set up specs
clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;

% set up and map 2D map
resolution = 10;
mapSize = [1000 1000];
submarineDimensions = [submarineLength submarineHeight];
disp('Generating list of obstacles');
listOfObstacles = generateObstacles(mapSize, norm(submarineDimensions)*2, resolution, true);
%load obstacleData;
disp('Made list of obstacles');
fullMap = generateMap(listOfObstacles, mapSize, false, resolution);
disp('testMapEnvironment-generated map');
[success, knownMap, finalPosition]=mapEnvironment(fullMap, resolution);

% set up and map 3D map
clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;
resolution = 20;
mapSize3D = [500 500 500];
submarineDimensions = [submarineLength submarineHeight submarineWidth];
disp('Generating list of obstacles 3D');
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
%load obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3D, mapSize3D, false, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D]=mapEnvironment(fullMap3D, resolution);

% set up and map 3D map with obstacles blocking floor
clear; clc; close all;
pkg load geometry;
loadSubmarineSpecifications;
resolution = 20;
mapSize3D = [500 500 500];
submarineDimensions = [submarineLength submarineHeight*4 submarineWidth*4];
disp('Generating list of obstacles 3D');
% set up obstacles to cover layer in checkerboard fashion
listOfObstacles3DBlocked = zeros(3, mapSize3D(1)*mapSize3D(2)/resolution^2/2);
col=1;
for k=1:2:mapSize3D(1)/resolution
  for m=1:2:mapSize3D(2)/resolution
    listOfObstacles3DBlocked(:,col) = [-250+resolution*(k-0.5); -250+resolution*(m-0.5); -250];
    col++;
    if (-250+resolution*(k+0.5)<251 && -250+resolution*(m+0.5)<251)
      listOfObstacles3DBlocked(:,col) = [-250+resolution*(k+0.5); -250+resolution*(m+0.5); -250];
      col++;
    endif
  endfor
endfor
listOfObstacles3D = generateObstacles(mapSize3D, norm(submarineDimensions)*2, resolution, true, true);
save obstacleData3D;
%load obstacleData3D;
disp('Made list of obstacles 3D');
fullMap3D = generateMap(listOfObstacles3DBlocked, mapSize3D, true, resolution);
disp('testMapEnvironment-generated map 3D');
[success, knownMap3D, finalPosition3D]=mapEnvironment(fullMap3D, resolution);