function [unknownMap]= generateUnknownMap(obstacleMap, submarineStartPoint, submarineDimensions, flashlightRange, resolution)
%  resolution = 0.5;
  % for map of the unknown: 0 is unknown, 1 is open, 2 is obstacle, 3 is submarine current position
  
  unknownMap = zeros(size(obstacleMap));
  submarineStartMapPoint = convertCoordinateToMap(submarineStartPoint, obstacleMap, resolution);
  disp(['Submarine start point: ', num2str(submarineStartPoint'), ', converted to map: ', num2str(submarineStartMapPoint')]);
  if (obstacleMap(submarineStartMapPoint(1), submarineStartMapPoint(2), submarineStartMapPoint(3)) != 0)
    error("start point is an obstacle");
  endif
  
  % sub knows area flashlight distance in every direction + sub dimension/2
  % dimension is length (along x) followed by width (along y) then depth (along z)
  x_edgeToCenter=submarineDimensions(1)/2;
  y_edgeToCenter=submarineDimensions(2)/2;
  z_edgeToCenter=submarineDimensions(3)/2;


% corners
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
          unknownMap(y, x, z)=3;
        endif
      endfor
    endfor
  endfor
  spots=0;
  obstacleMapSizes = [size(obstacleMap, 1) size(obstacleMap, 2) size(obstacleMap, 3)];
  maxOfCorners = [max(corners'); min(corners')];
  %get light information
  
  %shrink vectors as much as possible
  y_start = -flashlightRange-y_edgeToCenter+submarineStartPoint(2);
  x_start = -flashlightRange-x_edgeToCenter+submarineStartPoint(1);
  z_start = -flashlightRange-z_edgeToCenter+submarineStartPoint(3);
  startPointMap = convertCoordinateToMap([x_start, y_start, z_start], obstacleMap, resolution);
  % check map start point is within range
  altered = zeros(1,3);
  for k=1:3
    if startPointMap(k) < 1
      startPointMap(k) = 1;
      altered(k)=1;
    else if startPointMap(k) > obstacleMapSizes(k)
      startPointMap(k) = obstacleMapSizes(k);
      altered(k)=1;
    endif
    endif
  endfor
  
  finalStartPoint = convertMapToCoordinate(startPointMap, obstacleMap, resolution);
  x_start_c = x_start;
  if (altered(1) == 1)
    x_start_c = finalStartPoint(1)-resolution/2;
  endif
  y_start_c = y_start;
  if (altered(2) == 1)
    y_start_c = finalStartPoint(2)-resolution/2;
  endif
  z_start_c = z_start;
  if (altered(3) == 1)
    z_start_c = finalStartPoint(3)-resolution/2;
  endif
  % check map finish point is within range
  %shrink vectors as much as possible
  y_finish = flashlightRange+y_edgeToCenter+submarineStartPoint(2);
  x_finish = flashlightRange+x_edgeToCenter+submarineStartPoint(1);
  z_finish = flashlightRange+z_edgeToCenter+submarineStartPoint(3);
  finishPointMap = convertCoordinateToMap([x_finish, y_finish, z_finish], obstacleMap, resolution);
  % check map start point is within range
  altered = zeros(1,3);
  for k=1:3
    if finishPointMap(k) < 1
      finishPointMap(k) = 1;
      altered(k) = 1;
    else if finishPointMap(k) > obstacleMapSizes(k)
      finishPointMap(k) = obstacleMapSizes(k);
      altered(k) = 1;
    endif
    endif
  endfor
  
  finalFinishPoint = convertMapToCoordinate(finishPointMap, obstacleMap, resolution);
  x_finish_c = x_finish;
  if (altered(1) == 1)
    x_finish_c = finalStartPoint(1)+resolution/2;
  endif
  y_finish_c = y_finish;
  if (altered(2) == 1)
    y_finish_c = finalStartPoint(2)+resolution/2;
  endif
  z_finish_c = z_finish;
  if (altered(3) == 1)
    z_finish_c = finalStartPoint(3)+resolution/2;
  endif
  x_vect = x_start_c:resolution:x_finish_c;
  y_vect =y_start_c:resolution:y_finish_c;
  z_vect = z_start_c:resolution:z_finish_c;
  if (obstacleMapSizes(3) < 2)
    z_vect = 0;
  endif
  for y_c=y_vect
    for x_c=x_vect
      for z_c=z_vect
        disp(['Spots checked: ', num2str(spots)]);
        spots++;
        pointOnMap = convertCoordinateToMap([x_c, y_c, z_c]', obstacleMap, resolution);
        y = pointOnMap(1);
        x = pointOnMap(2);
        z = pointOnMap(3);
%        if (y<1 || y>obstacleMapSizes(1) || x<1 || x>obstacleMapSizes(2) || z<1 || z>obstacleMapSizes(3))
%          continue;
%        endif
        if (unknownMap(y, x, z) != 0)
          continue;
        else
          % only if point is within flashlight radius of a corner
          if (isVisible(x_c, y_c, z_c, x, y, z, flashlightRange, corners, cornersMap, obstacleMap, unknownMap, maxOfCorners, resolution))
            unknownMap(y, x, z)=obstacleMap(y, x, z)+1;          
          endif
        endif
      endfor
    endfor
  endfor
  
end


function visible=isVisible(x_c, y_c, z_c, x, y, z, flashlightRange, corners, cornersMap, obstacleMap, unknownMap, maxOfCorners, resolution)
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
