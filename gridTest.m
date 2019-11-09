clear; clc; close all;
figure;
hold on;
axis([-100 100 -100 100 -100 100]);
numberOfObstacles = floor(rand*1000);
for k=1:numberOfObstacles
  obstacleLLX = floor(rand*200) - 100;
  obstacleX = [obstacleLLX obstacleLLX obstacleLLX+1 obstacleLLX+1];
  obstacleLLY = floor(rand*200) - 100;
  obstacleY = [obstacleLLY obstacleLLY+1 obstacleLLY+1 obstacleLLY];
  obstacleLLZ = floor(rand*200) - 100;
  obstacleZ = [obstacleLLZ obstacleLLZ obstacleLLZ+1 obstacleLLZ+1];
  drawCube([obstacleLLX obstacleLLY obstacleLLZ 1 0 0 0], 'FaceColor', 'r');

endfor
