function figureHandle=plotKnownMap(knownMap, resolution, figureHandle=0)
twoDimensions=true;
if size(knownMap,3)>1
  twoDimensions=false;
endif
dimensions=size(knownMap);

if (figureHandle == 0)
  figureHandle=figure;
else
  figure(figureHandle);
endif
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
if(twoDimensions)
  map = zeros(dimensions(1), dimensions(2));  
else
  map = zeros(dimensions(1), dimensions(2), dimensions(3));
endif
shiftValue = 0.5*resolution;
for y = 1:size(knownMap, 1)
  for x = 1:size(knownMap, 2)
    for z = 1:size(knownMap, 3)
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
  endfor
endfor
endfunction
