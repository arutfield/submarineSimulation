function figureHandle = plotMap(map, listOfObstacles, dimensions, resolution, twoDimensions)
      % set up display
    figureHandle=figure();
    hold on;
    axisVector=[];
    for d=1:2
      axisVector = [axisVector -dimensions(d)/2 dimensions(d)/2];
    endfor
    if !twoDimensions
      axisVector = [axisVector -dimensions(3) 0];
    endif
    axis(axisVector);
  for ob = 1:size(listOfObstacles, 2)
      % have to line up to grid if plotting
      mapCoordinates=convertCoordinateToMap(listOfObstacles(:, ob), map, resolution);
      mappedCoordinates=convertMapToCoordinate(mapCoordinates, map, resolution);
      if twoDimensions
        x = [mappedCoordinates(1)-0.5*resolution mappedCoordinates(1)-0.5*resolution...
        mappedCoordinates(1)+0.5*resolution mappedCoordinates(1)+0.5*resolution];
        y = [mappedCoordinates(2)-0.5*resolution mappedCoordinates(2)+0.5*resolution...
        mappedCoordinates(2)+0.5*resolution mappedCoordinates(2)-0.5*resolution];
        fill(x, y, 'r');
      else
        drawCube([mappedCoordinates(1) mappedCoordinates(2) mappedCoordinates(3) resolution 0 0 0], 'FaceColor', 'r');
      endif
  endfor

  
  
endfunction
