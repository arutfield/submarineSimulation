function [map, figureHandle] = generateMap(listOfObstacles, dimensions, display)
  twoDimensions=true;
  if size(dimensions,2)==3
    twoDimensions=false;
  endif
  if(display)
    % set up display
    figureHandle=figure;
    hold on;
    axisVector=[];
    for d=1:2
      axisVector = [axisVector -dimensions(d)/2 dimensions(d)/2];
    endfor
    if !twoDimensions
      axisVector = [axisVector -dimensions(3) 0];
    endif
    axis(axisVector);
  endif
  if(twoDimensions)
    map = zeros(dimensions(2), dimensions(1));  
  else
    map = zeros(dimensions(2), dimensions(1), dimensions(3));
  endif
  for ob = 1:size(listOfObstacles, 2)
    mapCoordinates = convertCoordinateToMap(listOfObstacles(:,ob), map);
    map(mapCoordinates(1), mapCoordinates(2), mapCoordinates(3)) = 1;
    if(display)
      if twoDimensions
        x = [listOfObstacles(1,ob)-0.5 listOfObstacles(1,ob)-0.5...
        listOfObstacles(1,ob)+0.5 listOfObstacles(1,ob)+0.5];
        y = [listOfObstacles(2,ob)-0.5 listOfObstacles(2,ob)+0.5...
        listOfObstacles(2,ob)+0.5 listOfObstacles(2,ob)-0.5];
        fill(x, y, 'r');
      else
        drawCube([listOfObstacles(1,ob) listOfObstacles(2,ob) listOfObstacles(3,ob) 1 0 0 0], 'FaceColor', 'r');
      endif
    endif
  endfor
  
endfunction
