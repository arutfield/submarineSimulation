function [knownMap, figureHandle, totalTime] = animateWaveformMovement(knownMap, fullMap, wavefrontPathMap, submarineDimensions, flashlightRange, resolution, maxSpeed, acceleration, deceleration);
  twoDimensions=true;
  if size(knownMap,3)>1
    twoDimensions=false;
  endif
  dimensions=size(knownMap);
  figureHandle=plotKnownMap(knownMap, resolution);
  set(gca, 'Color', 'k');
  hold on;
  axisVector=[];
  for d=1:2
    axisVector = [axisVector -dimensions(3-d)/2*resolution dimensions(3-d)/2*resolution];
  endfor
  if !twoDimensions
    axisVector = [axisVector -dimensions(3)*resolution 0];
  endif
  
  axis(axisVector);
  
  totalTime = 0;
  prevPositionMap = [-1 -1 -1]';
  for v=1:size(wavefrontPathMap,2)
    wavefrontPath(:,v)=convertMapToCoordinate(wavefrontPathMap(:,v), knownMap, resolution);
  endfor
  for k=2:size(wavefrontPath,2)
    [trajectory, time]=generateTrapezoidalTrajectory(wavefrontPath(:,k-1),...
    wavefrontPath(:,k), maxSpeed, acceleration, deceleration);
    for m=1:size(trajectory,2)
      subPosition = trajectory(:,m);
      subPositionMap = convertCoordinateToMap(subPosition, knownMap, resolution);
      if (isequal(subPositionMap, prevPositionMap))
        continue;
      endif
      [knownMap, newLocations ]=updateMap(fullMap, knownMap, subPosition, submarineDimensions, flashlightRange, resolution);
      plotUpdatedMap(knownMap, resolution, dimensions, twoDimensions, newLocations);
      pause(0.01);
      prevPositionMap = subPositionMap;
    endfor
    totalTime = totalTime + time(end);
  endfor
  
endfunction


function figureHandle=plotUpdatedMap(knownMap, resolution, dimensions, twoDimensions, newLocations)
  if(twoDimensions)
  map = zeros(dimensions(1), dimensions(2));  
else
  map = zeros(dimensions(1), dimensions(2), dimensions(3));
endif

% move sub


shiftValue = 0.5*resolution;
for k = 1:size(newLocations, 2)
      y=newLocations(1,k);
      x=newLocations(2,k);
      z=newLocations(3,k);
      value = knownMap(y, x, z);
      if (value == 0)
        continue;
      endif
      
      coordinatePoint = convertMapToCoordinate([y x z]', knownMap, resolution);
      x_c=coordinatePoint(1);
      y_c=coordinatePoint(2);
      z_c=coordinatePoint(3);
      if twoDimensions
        x_vect = [x_c-shiftValue x_c-shiftValue x_c+shiftValue x_c+shiftValue];
        y_vect = [y_c-shiftValue y_c+shiftValue y_c+shiftValue y_c-shiftValue];
        switch value
          case 1
            fill(x_vect, y_vect, 'w', 'EdgeColor', 'None');
          case 2
            fill(x_vect, y_vect, 'r', 'EdgeColor', 'None');
          case 3
            fill(x_vect, y_vect, 'g', 'EdgeColor', 'None');
          otherwise
            error(["unknown value: ", num2str(value)]);
          end
      else
        switch value
          case 1
            drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'w', 'EdgeColor', 'None');
          case 2
            drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'r', 'EdgeColor', 'None');
          case 3
            drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'g', 'EdgeColor', 'None');
          otherwise
            error(["unknown value: ", num2str(value)]);
          end
      endif
endfor
endfunction
