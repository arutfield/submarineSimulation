function [updatedMap] = updateMap(obstacleMap, knownMap, submarineStartPoint, submarineDimensions, flashlightRange, resolution)
  updatedMap = knownMap;
  submarineStartMapPoint = convertCoordinateToMap(submarineStartPoint, obstacleMap, resolution);
  disp(['Submarine start point: ', num2str(submarineStartPoint'), ', converted to map: ', num2str(submarineStartMapPoint')]);
  if (obstacleMap(submarineStartMapPoint(1), submarineStartMapPoint(2), submarineStartMapPoint(3)) != 0)
    error("start point is an obstacle");
  endif
  % remove original sub
  for r=1:size(knownMap,1)
    for c=1:size(knownMap,2)
      for d=1:size(knownMap,3)
        if (knownMap(r,c,d)==3)
          updatedMap(r,c,d)=obstacleMap(r,c,d)+1;  
        endif
      endfor
    endfor
  endfor
  
  
  % sub knows area flashlight distance in every direction + sub dimension/2
  % dimension is length (along x) followed by width (along y) then depth (along z)
  x_edgeToCenter=submarineDimensions(1)/2;
  y_edgeToCenter=submarineDimensions(2)/2;
  z_edgeToCenter=submarineDimensions(3)/2;

    corners = [...
submarineStartPoint(1)+x_edgeToCenter, submarineStartPoint(1)+x_edgeToCenter,...
submarineStartPoint(1)+x_edgeToCenter, submarineStartPoint(1)+x_edgeToCenter,...
submarineStartPoint(1)-x_edgeToCenter, submarineStartPoint(1)-x_edgeToCenter,...
submarineStartPoint(1)-x_edgeToCenter, submarineStartPoint(1)-x_edgeToCenter;...
submarineStartPoint(2)+y_edgeToCenter, submarineStartPoint(2)+y_edgeToCenter,...
submarineStartPoint(2)-y_edgeToCenter, submarineStartPoint(2)-y_edgeToCenter,...
submarineStartPoint(2)+y_edgeToCenter, submarineStartPoint(2)+y_edgeToCenter,...
submarineStartPoint(2)-y_edgeToCenter, submarineStartPoint(2)-y_edgeToCenter;...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter,...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter,...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter,...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter];

%testCorner = [submarineStartPoint(1)+x_edgeToCenter; submarineStartPoint(2)+y_edgeToCenter; submarineStartPoint(3)+z_edgeToCenter];

cornersMap = zeros(size(corners));
for k=1:size(corners,2)
  cornersMap(:,k) = convertCoordinateToMap(corners(:,k), obstacleMap, resolution);  
endfor
for r=1:size(corners,1)
  for c=1:size(corners, 2)
    if (cornersMap(r,c) < 1 || cornersMap(r,c) > size(obstacleMap, r))
      error(["corner off board: ", num2str(r), ",", num2str(c)]);
    endif
  endfor
endfor
  
  
  % get sub spots by dimension
  for y_c=-y_edgeToCenter+submarineStartPoint(2):resolution:y_edgeToCenter+submarineStartPoint(2)
    for x_c=-x_edgeToCenter+submarineStartPoint(1):resolution:x_edgeToCenter+submarineStartPoint(1)
      for z_c=-z_edgeToCenter+submarineStartPoint(3):resolution:z_edgeToCenter+submarineStartPoint(3)
        pointOnMap = convertCoordinateToMap([x_c, y_c, z_c]', obstacleMap, resolution);
        y = pointOnMap(1);
        x = pointOnMap(2);
        z = pointOnMap(3);
        
        if (obstacleMap(y, x, z) != 0)
          error("point is an obstacle, no room for a sub");
        else
          updatedMap(y, x, z)=3;
        endif
      endfor
    endfor
  endfor
  spots=0;
  obstacleMapSizes = [size(obstacleMap, 1) size(obstacleMap, 2) size(obstacleMap, 3)];
  maxOfCorners = [max(corners'); min(corners')];
  %get light information
  
     % get corners in coordinate frame
   vector_ult = convertMapToCoordinate(ones(3,1), obstacleMap, resolution);
   tol = resolution/2-1e-3;
   y_max_c = vector_ult(2)+tol;
   x_min_c = vector_ult(1)-tol;
   z_max_c = vector_ult(3)+tol;
   
   vector_lrb = convertMapToCoordinate([size(obstacleMap, 1), size(obstacleMap, 2), size(obstacleMap, 3)], obstacleMap, resolution);
   y_min_c = vector_lrb(2)-tol;
   x_max_c = vector_lrb(1)+tol;
   z_min_c = vector_lrb(3)-tol;

  
  %shrink vectors as much as possible
  y_start = -flashlightRange-y_edgeToCenter+submarineStartPoint(2);
  x_start = -flashlightRange-x_edgeToCenter+submarineStartPoint(1);
  z_start = -flashlightRange-z_edgeToCenter+submarineStartPoint(3);

    % check map finish point is within range
    if (y_start < y_min_c)
      y_start = y_min_c;
    endif
    if (x_start < x_min_c)
      x_start = x_min_c;
    endif
    if (z_start < z_min_c)
      z_start = z_min_c;
    endif
  %shrink vectors as much as possible
  y_finish = flashlightRange+y_edgeToCenter+submarineStartPoint(2);
  x_finish = flashlightRange+x_edgeToCenter+submarineStartPoint(1);
  z_finish = flashlightRange+z_edgeToCenter+submarineStartPoint(3);

    if (y_finish > y_max_c)
      y_finish = y_max_c;
    endif
    if (x_finish > x_max_c)
      x_finish = x_max_c;
    endif
    if (z_finish > z_max_c)
      z_finish = z_max_c;
    endif

  
  x_vect = x_start:resolution:x_finish;
  y_vect =y_start:resolution:y_finish;
  z_vect = z_start:resolution:z_finish;
  if (obstacleMapSizes(3) < 2)
    z_vect = 0;
  endif
  for y_c=y_vect
    for x_c=x_vect
      for z_c=z_vect
        pointOnMap = convertCoordinateToMap([x_c, y_c, z_c]', obstacleMap, resolution);
        y = pointOnMap(1);
        x = pointOnMap(2);
        z = pointOnMap(3);
        if (y<1 || y>obstacleMapSizes(1) || x<1 || x>obstacleMapSizes(2) || z<1 || z>obstacleMapSizes(3))
          continue;
        endif
        if (updatedMap(y, x, z) != 0)
          continue;
        else
          spots++;

          % only if point is within flashlight radius of a corner
          [updatedMap, visible] = isVisible(x_c, y_c, z_c, x, y, z, flashlightRange, corners, cornersMap, obstacleMap, updatedMap, maxOfCorners, resolution);
          if (visible)
            if (obstacleMap(y, x, z) == 2)
              updatedMap(y, x, z) = 2;
            else
              updatedMap(y, x, z) = 1;
            endif
          endif
        endif
      endfor
    endfor
  endfor
  disp(['Spots checked: ', num2str(spots)]);
  
end


function [updatedMap, visible]=isVisible(x_c, y_c, z_c, x, y, z, flashlightRange, corners, cornersMap, obstacleMap, updatedMap, maxOfCorners, resolution)
  %corners = corners(:,1);
  visible = false;
  cornersInRange = [];

for c=1:size(corners,2)
  if (norm([x_c-corners(1,c), y_c-corners(2,c), z_c-corners(3,c)]) <= flashlightRange)
    cornersInRange = [cornersInRange corners(:,c)];    
  endif

endfor

allclear = false;

  if (size(cornersInRange,2) < 1)
    return;
  endif
  
  % tough part - make sure there are no obstacles between it and sub
  
  provenClear = false;
  for k=1:size(cornersInRange,2)
    cornerInMap = convertCoordinateToMap(cornersInRange(:,k), obstacleMap, resolution);
    dx = x_c-cornersInRange(1,k);
    dy = y_c-cornersInRange(2,k);
    dz = z_c-cornersInRange(3,k);
    N = norm([dx, dy, dz]);
    a=1;
    pathNotClear = false;
    increment = resolution/N;
    proportion = a*increment;
    while (proportion < 1)
       pointToCheck = [cornersInRange(1,k)+proportion*dx; cornersInRange(2,k)+proportion*dy; cornersInRange(3,k)+proportion*dz];
       pointToCheckMap = convertCoordinateToMap(pointToCheck, obstacleMap, resolution);
       if (isequal(pointToCheckMap, [y x z]') || isequal(pointToCheckMap, cornerInMap))
         break;
       endif
       if (updatedMap(pointToCheckMap(1), pointToCheckMap(2), pointToCheckMap(3)) == 0)
         updatedMap(pointToCheckMap(1), pointToCheckMap(2), pointToCheckMap(3)) = obstacleMap(pointToCheckMap(1), pointToCheckMap(2), pointToCheckMap(3));
       endif
       if (obstacleMap(pointToCheckMap(1), pointToCheckMap(2), pointToCheckMap(3)) > 0 ||...
         (pointToCheck(1) > maxOfCorners(2,1) && pointToCheck(1) < maxOfCorners(1,1) &&...
         pointToCheck(2) > maxOfCorners(2,2) && pointToCheck(2) < maxOfCorners(1,2) &&...
         pointToCheck(3) > maxOfCorners(2,3) && pointToCheck(3) < maxOfCorners(1,3)))
         pathNotClear = true;
         break;
       endif
       a++;
       proportion = a*increment;
       
    endwhile
    if (!pathNotClear)
      provenClear = true;
      break;
    endif
  endfor
  if (!provenClear)
    return;
  endif
  visible = true;
endfunction
