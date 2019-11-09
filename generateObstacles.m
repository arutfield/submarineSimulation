  function allObstacles = generateObstacles(threeDimensions, sideLengths)
    %clear; clc; close all;
    if length(sideLengths) != 3 && threeDimensions
      error("number of lengths must be 3 if three dimensions");
    else
      if length(sideLengths) != 2 && !threeDimensions
        error ("number of lengths must be 2 if two dimensions");
      endif
    endif
    figure;
    hold on;
    axisVector=[];
    allObstacles = [];
    for d=1:2
      axisVector = [axisVector -sideLengths(d)/2 sideLengths(d)/2];
    endfor
    if threeDimensions
      axisVector = [axisVector -sideLengths(3) 0];
    endif
    axis(axisVector);
    numberOfObstacles = round(rand*prod(sideLengths)*0.2);
    for k=1:numberOfObstacles
      obstacleCenterX = round(rand*(sideLengths(1)-1)) - (sideLengths(1)-1)/2;
      obstacleX = [obstacleCenterX-0.5 obstacleCenterX-0.5 obstacleCenterX+0.5 obstacleCenterX+0.5];
      obstacleCenterY = round(rand*(sideLengths(2)-1)) - (sideLengths(2)-1)/2;
      obstacleY = [obstacleCenterY-0.5 obstacleCenterY+0.5 obstacleCenterY+0.5 obstacleCenterY-0.5];
      if !threeDimensions
        fill(obstacleX, obstacleY, 'r');
        allObstacles = [allObstacles [obstacleCenterX; obstacleCenterY; 0]];
      else
        obstacleCenterZ = -round(rand*(sideLengths(3)-1))-0.5;
        obstacleZ = [obstacleCenterZ-0.5 obstacleCenterZ-0.5 obstacleCenterZ+0.5 obstacleCenterZ+0.5];
        drawCube([obstacleCenterX obstacleCenterY obstacleCenterZ 1 0 0 0], 'FaceColor', 'r');
        allObstacles = [allObstacles [obstacleCenterX; obstacleCenterY; obstacleCenterZ]];
      endif
    endfor
  
  endfunction
