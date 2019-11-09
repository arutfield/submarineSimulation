function [unknownMap]= generateUnknownMap(obstacleMap, submarineStartPoint, submarineDimensions, flashlightRange)
   % for map of the unknown: 0 is unknown, 1 is open, 2 is obstacle, 3 is submarine current position
   
   unknownMap = zeros(size(obstacleMap));
   submarineStartMapPoint = convertCoordinateToMap(submarineStartPoint, obstacleMap);
   if (obstacleMap(submarineStartMapPoint(1), submarineStartMapPoint(2), submarineStartMapPoint(3)) != 0)
     error("start point is an obstacle");
   %else
   %  unknownMap(submarineStartMapPoint(1), submarineStartMapPoint(2), submarineStartMapPoint(3))=3;
   endif

   % sub knows area flashlight distance in every direction + sub dimension/2
   % dimension is length (along x) followed by width (along y) then depth (along z)
   x_edgeToCenter=submarineDimensions(1)/2;
   y_edgeToCenter=submarineDimensions(2)/2;
   z_edgeToCenter=submarineDimensions(3)/2;
   
   if (x_edgeToCenter+submarineStartMapPoint(2) < 1 ...
     || x_edgeToCenter+submarineStartMapPoint(2) > size(obstacleMap,2))
     error(["x edge is off grid. Cannot place submarine here. start point on map: ", num2str(submarineStartMapPoint(1)), " ", num2str(submarineStartMapPoint(2)), " ", num2str(submarineStartMapPoint(3))]);
   endif
   if (y_edgeToCenter+submarineStartMapPoint(1) < 1 ...
     || y_edgeToCenter+submarineStartMapPoint(1) > size(obstacleMap,1))
     error(["y edge is off grid. Cannot place submarine here. start point on map: ", num2str(submarineStartMapPoint(1)), " ", num2str(submarineStartMapPoint(2)), " ", num2str(submarineStartMapPoint(3))]);
   endif
   if (z_edgeToCenter+submarineStartMapPoint(3) < 1 ...
     || z_edgeToCenter+submarineStartMapPoint(3) > size(obstacleMap,3))
     error(["z edge is off grid. Cannot place submarine here. start point on map: ", num2str(submarineStartMapPoint(1)), " ", num2str(submarineStartMapPoint(2)), " ", num2str(submarineStartMapPoint(3))]);
   endif
   
   % get sub spots by dimension
   for y=-y_edgeToCenter+submarineStartMapPoint(1):y_edgeToCenter+submarineStartMapPoint(1)
     for x=-x_edgeToCenter+submarineStartMapPoint(2):x_edgeToCenter+submarineStartMapPoint(2)
       for z=-z_edgeToCenter+submarineStartMapPoint(3):z_edgeToCenter+submarineStartMapPoint(3)
         if (obstacleMap(y, x, z) != 0)
           error("point is an obstacle, no room for a sub");
         else
           unknownMap(y, x, z)=3;
         endif
       endfor
     endfor
   endfor
   
   %get light information
   for y=-flashlightRange-y_edgeToCenter+submarineStartMapPoint(1):y_edgeToCenter+submarineStartMapPoint(1)+flashlightRange
     for x=-flashlightRange-x_edgeToCenter+submarineStartMapPoint(2):x_edgeToCenter+submarineStartMapPoint(2)+flashlightRange
       for z=-flashlightRange-z_edgeToCenter+submarineStartMapPoint(3):z_edgeToCenter+submarineStartMapPoint(3)+flashlightRange
         if (y<1 || y>size(obstacleMap,1) || x<1 || x>size(obstacleMap,2) || z<1 || z>size(obstacleMap,3))
           continue;
         endif
         if (unknownMap(y, x, z) != 0)
           continue;
         else
           % only if point is within flashlight radius of a corner
           if (norm([x-(submarineStartMapPoint(2)+x_edgeToCenter), y-(submarineStartMapPoint(1)+y_edgeToCenter), z-(submarineStartMapPoint(3)+z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)+x_edgeToCenter), y-(submarineStartMapPoint(1)+y_edgeToCenter), z-(submarineStartMapPoint(3)-z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)+x_edgeToCenter), y-(submarineStartMapPoint(1)-y_edgeToCenter), z-(submarineStartMapPoint(3)+z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)+x_edgeToCenter), y-(submarineStartMapPoint(1)-y_edgeToCenter), z-(submarineStartMapPoint(3)-z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)-x_edgeToCenter), y-(submarineStartMapPoint(1)+y_edgeToCenter), z-(submarineStartMapPoint(3)+z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)-x_edgeToCenter), y-(submarineStartMapPoint(1)+y_edgeToCenter), z-(submarineStartMapPoint(3)-z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)-x_edgeToCenter), y-(submarineStartMapPoint(1)-y_edgeToCenter), z-(submarineStartMapPoint(3)+z_edgeToCenter)]) <= flashlightRange...
               || norm([x-(submarineStartMapPoint(2)-x_edgeToCenter), y-(submarineStartMapPoint(1)-y_edgeToCenter), z-(submarineStartMapPoint(3)-z_edgeToCenter)]) <= flashlightRange)
               unknownMap(y, x, z)=(obstacleMap(y, x, z)+1);
           endif
         endif
       endfor
     endfor
   endfor
   
end