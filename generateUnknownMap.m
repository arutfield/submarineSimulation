function [unknownMap]= generateUnknownMap(obstacleMap, submarineStartPoint, submarineDimensions, flashlightRange)
  resolution = 0.5;
  % for map of the unknown: 0 is unknown, 1 is open, 2 is obstacle, 3 is submarine current position
  
  unknownMap = zeros(size(obstacleMap));
  submarineStartMapPoint = convertCoordinateToMap(submarineStartPoint, obstacleMap);
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
  corners = [submarineStartPoint(1)+x_edgeToCenter, submarineStartPoint(1)+x_edgeToCenter,...
submarineStartPoint(1)+x_edgeToCenter, submarineStartPoint(1)+x_edgeToCenter,...
submarineStartPoint(1)-x_edgeToCenter, submarineStartPoint(1)-x_edgeToCenter,...
submarineStartPoint(1)-x_edgeToCenter, submarineStartPoint(1)-x_edgeToCenter;
submarineStartPoint(2)+y_edgeToCenter, submarineStartPoint(2)+y_edgeToCenter,...
submarineStartPoint(2)-y_edgeToCenter, submarineStartPoint(2)-y_edgeToCenter,...
submarineStartPoint(2)+y_edgeToCenter, submarineStartPoint(2)+y_edgeToCenter,...
submarineStartPoint(2)-y_edgeToCenter, submarineStartPoint(2)-y_edgeToCenter;...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter,...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter,...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter,...
submarineStartPoint(3)+z_edgeToCenter, submarineStartPoint(3)-z_edgeToCenter];


cornersMap = zeros(3,8);
for k=1:size(corners,2)
  cornersMap(:,k) = convertCoordinateToMap(corners(:,k), obstacleMap);  
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
        pointOnMap = convertCoordinateToMap([x_c, y_c, z_c]', obstacleMap);
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

  
  %get light information
  for y_c=-flashlightRange-y_edgeToCenter+submarineStartPoint(2):resolution:y_edgeToCenter+submarineStartPoint(2)+flashlightRange
    for x_c=-flashlightRange-x_edgeToCenter+submarineStartPoint(1):resolution:x_edgeToCenter+submarineStartPoint(1)+flashlightRange
      for z_c=-flashlightRange-z_edgeToCenter+submarineStartPoint(3):resolution:z_edgeToCenter+submarineStartPoint(3)+flashlightRange
        pointOnMap = convertCoordinateToMap([x_c, y_c, z_c]', obstacleMap);
        y = pointOnMap(1);
        x = pointOnMap(2);
        z = pointOnMap(3);
        if (y<1 || y>size(obstacleMap,1) || x<1 || x>size(obstacleMap,2) || z<1 || z>size(obstacleMap,3))
          continue;
        endif
        if (unknownMap(y, x, z) != 0)
          continue;
        else
          % only if point is within flashlight radius of a corner
          if (isVisible(x_c, y_c, z_c, x, y, z, flashlightRange, corners, cornersMap, obstacleMap))
            unknownMap(y, x, z)=(obstacleMap(y, x, z)+1);          
          endif
        endif
      endfor
    endfor
  endfor
  
end


function visible=isVisible(x_c, y_c, z_c, x, y, z, flashlightRange, corners, cornersMap, obstacleMap)
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
%  for r=1:size(cornersInRange, 2)
%    differences = [x-cornersInRange(1,r) y-cornersInRange(2,r) z-cornersInRange(3,r)];
%    abs_differences = abs(differences);
%    unblocked = true;
    % check if horizontal or vertical
%    if (abs_differences(2)<0.5 && abs_differences(3)<0.5)
%      increment = (differences(1)/abs_differences(1));
%      subPoint = [x-increment y z];
      
%      while (abs(subPoint(1)-cornersInRange(1,r))<1)
 %       if (obstacleMap(subPoint(1), y, z) > 0)
 %         unblocked = false;
  %        break;
  %      endif
  %      subPoint(1) = subPoint(1)-increment;
  %    endwhile
  %  endif
    
    
   % subPoint = [x y z]';
    %while(norm([subPoint(1)-cornersInRange(2,r), subPoint(2)-cornersInRange(1,c), subPoint-cornersInRange(3,c)]) >= 1)
       
    %endwhile
%    if unblocked
 %     allclear = true;
  %    break;
  %  endif
  %endfor
  %if !allclear
  %  return;
  %endif
  
  visible = true;
endfunction
