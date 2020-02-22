% generateObstacles - create obstacles on the map
%  inputs:
%   sideLengths - side lengths of map
%   distanceFromSubOrigin - minimum distance an obstacle can be from sub
%   resolution - map resolution
%   visual - boolean indicating if you want to see plot
%   test - fixed number of 1000 obstacles if true (default=false)
%  outputs:
%   allObstacles - all obstacles coordinates generated
  function allObstacles = generateObstacles(sideLengths, distanceFromSubOrigin, resolution, visual, test=false)
    %clear; clc; close all;
    if (visual)
      figure;
      hold on;
      axisVector=[];
      allObstacles = [];
    endif
    for d=1:2
      axisVector = [axisVector -sideLengths(d)/2 sideLengths(d)/2];
    endfor
    if length(sideLengths) > 2
      axisVector = [axisVector -sideLengths(3) 0];
    endif
    if (visual)
      axis(axisVector);
    endif
    numberOfObstacles = round(rand*prod(sideLengths)*0.01/resolution);
    if (test)
      numberOfObstacles=1000;
    endif
    disp(["number of obstacles: ", num2str(numberOfObstacles)]);
    
    for k=1:numberOfObstacles
      obstacleCenterX = (rand*(sideLengths(1)/2-0.5))*(-1)^(round(rand-1));
      obstacleX = [obstacleCenterX-0.5 obstacleCenterX-0.5 obstacleCenterX+0.5 obstacleCenterX+0.5];
      obstacleCenterY = (rand*(sideLengths(2)/2-0.5))*(-1)^(round(rand-1));
      obstacleY = [obstacleCenterY-0.5 obstacleCenterY+0.5 obstacleCenterY+0.5 obstacleCenterY-0.5];
      
      if (length(sideLengths) < 3)
        if norm([obstacleX obstacleY])<distanceFromSubOrigin
          continue;
        endif
        if (visual)
          fill(obstacleX, obstacleY, 'r');
        endif
        allObstacles = [allObstacles [obstacleCenterX; obstacleCenterY; 0]];
      else
        obstacleCenterZ = -rand*(sideLengths(3)-resolution/2)+0.5;
        obstacleZ = [obstacleCenterZ-0.5 obstacleCenterZ-0.5 obstacleCenterZ+0.5 obstacleCenterZ+0.5];
        if norm([obstacleX obstacleY obstacleZ])<distanceFromSubOrigin
          continue;
        endif
        if (visual)
          drawCube([obstacleCenterX obstacleCenterY obstacleCenterZ 0.5 0 0 0], 'FaceColor', 'r');
        endif
        allObstacles = [allObstacles [obstacleCenterX; obstacleCenterY; obstacleCenterZ]];
      endif
    endfor
  
  endfunction
