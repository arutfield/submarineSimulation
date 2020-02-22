% plotKnownMap - plot map where some areas are unknown
%  inputs
%    knownMap - map where parts are known
%    resolution - resolution of map
%    oldSubmarineHandles - figure handles of cubes representing submarine
%    figureHandle - figure handle to use (default=0)
%  outputs
%    figureHandle - new figure handle to use for this plot
%    submarineHanldes - figure handles of submarine locations
function [figureHandle, submarineHandles]=plotKnownMap(knownMap, resolution, oldSubmarineHandles, figureHandle=0)
twoDimensions=true;
if size(knownMap,3)>1
  twoDimensions=false;
endif
dimensions=size(knownMap);
submarineHandles = [];
if (figureHandle == 0)
  figureHandle=  figure('position', [500 500, 1000, 1000]);;
else
  figure(figureHandle, 'position', [500 500, 1000, 1000]);
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
if (!twoDimensions)
  for k=1:length(oldSubmarineHandles)
    delete(oldSubmarineHandles(k));
  endfor
endif
subIndex=1;
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
            drawCube([x_c y_c z_c resolution/2 0 0 0], 'FaceColor', 'w', 'EdgeColor', 'None');
          case 2
            drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'r', 'EdgeColor', 'None');
          case 3
            submarineHandles(subIndex) = drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'g', 'EdgeColor', 'None');
            subIndex++;
          otherwise
            error(["unknown value: ", num2str(value)]);
          end
      endif
    endfor
  endfor
endfor
endfunction
