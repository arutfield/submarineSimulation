function figureHandle=plotKnownMap(knownMap)
resolution = 0.5;
twoDimensions=true;
if size(knownMap,3)>1
  twoDimensions=false;
endif
dimensions=size(knownMap);
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
if(twoDimensions)
  map = zeros(dimensions(1), dimensions(2));  
else
  map = zeros(dimensions(1), dimensions(2), dimensions(3));
endif
for y = 1:size(knownMap, 1)
  for x = 1:size(knownMap, 2)
    for z = 1:size(knownMap, 3)
      coordinatePoint = convertMapToCoordinate([y x z]', knownMap);
      x_c=coordinatePoint(1);
      y_c=coordinatePoint(2);
      z_c=coordinatePoint(3);
      if twoDimensions
        value = knownMap(y, x, z);
        if (value == 1)
          continue;
        endif
        x_vect = [x_c-0.5*resolution x_c-0.5*resolution x_c+0.5*resolution x_c+0.5*resolution];
        y_vect = [y_c-0.5*resolution y_c+0.5*resolution y_c+0.5*resolution y_c-0.5*resolution];
        switch value
          case 0
            fill(x_vect, y_vect, 'k');
          case 2
            fill(x_vect, y_vect, 'r');
          case 3
            fill(x_vect, y_vect, 'g');
          otherwise
            error(["unknown value: ", num2str(value)]);
          end
      else
          
          %drawCube([listOfObstacles(1,ob) listOfObstacles(2,ob) listOfObstacles(3,ob) 1 0 0 0], 'FaceColor', 'r');
      endif
    endfor
  endfor
endfor
endfunction
