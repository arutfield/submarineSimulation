function [map, figureHandle] = generateMap(listOfObstacles, dimensions, display, resolution)
  twoDimensions=true;
  if size(dimensions,2)==3
    twoDimensions=false;
  endif
  figureHandle=0;
  if(twoDimensions)
    map = zeros(round(dimensions(2)/resolution), round(dimensions(1)/resolution));  
  else
    map = zeros(round(dimensions(2)/resolution), round(dimensions(1)/resolution), round(dimensions(3)/resolution));
  endif
  for ob = 1:size(listOfObstacles, 2)
    mapCoordinates = convertCoordinateToMap(listOfObstacles(:,ob), map, resolution, twoDimensions);
    map(mapCoordinates(1), mapCoordinates(2), mapCoordinates(3)) = 2;
  endfor
  if(display)
    figureHandle=plotMap(map, listOfObstacles, dimensions, resolution, twoDimensions);
  endif
  
endfunction
