function figureHandle = plotFrontierMap(map, frontier, centroid, resolution)
  mapSizes = [size(map, 1) size(map, 2) size(map, 3)];
  figureHandle = plotKnownMap(map, resolution, []);
  figure(figureHandle);
  hold on;
  shiftValue = 0.25*resolution;
  twoDimensions=true;
  if size(map,3)>1
    twoDimensions=false;
  endif

  for k=1:length(frontier)
      coordinatePoint = convertMapToCoordinate(frontier(:,k), map, resolution);
      x_c=coordinatePoint(1);
      y_c=coordinatePoint(2);
      z_c=coordinatePoint(3);
      if twoDimensions
        x_vect = [x_c-shiftValue x_c-shiftValue x_c+shiftValue x_c+shiftValue];
        y_vect = [y_c-shiftValue y_c+shiftValue y_c+shiftValue y_c-shiftValue];
        fill(x_vect, y_vect, 'b', 'EdgeColor', 'None');
      else
        drawCube([x_c y_c z_c resolution/2 0 0 0], 'FaceColor', 'b');
      endif
  endfor
  
  coordinatePoint = convertMapToCoordinate(centroid, map, resolution);
  if twoDimensions
      x_vect = [coordinatePoint(1)-shiftValue coordinatePoint(1)-shiftValue coordinatePoint(1)+shiftValue coordinatePoint(1)+shiftValue];
      y_vect = [coordinatePoint(2)-shiftValue coordinatePoint(2)+shiftValue coordinatePoint(2)+shiftValue coordinatePoint(2)-shiftValue];
      fill(x_vect, y_vect, 'm', 'EdgeColor', 'None');
  else
      drawCube([coordinatePoint(1) coordinatePoint(2) coordinatePoint(3) resolution/2 0 0 0], 'FaceColor', 'm');
  endif
  
endfunction
