function [frontierCentroidMap, frontierMap] = findFrontierCentroid(expandedObstacleMap, currentPositionMap=zeros(3,1))
##  frontierMap = [];
##  backupSpotsMap = [];
##  mapSizes = [size(expandedObstacleMap,1) size(expandedObstacleMap,2) size(expandedObstacleMap,3)];
##  for r=1:mapSizes(1)
##    for c=1:mapSizes(2)
##      for d=1:mapSizes(3)
##        spot = expandedObstacleMap(r, c, d);
##        if (spot == 1)
##          for k=-1:1
##            if (r+k < 1 || r+k>mapSizes(1))
##              continue;
##            endif
##            for l=-1:1
##              if (c+l < 1 || c+l>mapSizes(2))
##                continue;
##              endif
##              for m=-1:1
##                if (d+m < 1 || d+m>mapSizes(3) || (m==0 && l==0 && k==0))
##                  continue;
##                endif
##                if (expandedObstacleMap(r+k, c+l, d+m) == 0)
##                  frontierMap = [frontierMap [(2*r+k)/2; (2*c+l)/2; (2*d+m)/2]];
##                  backupSpotsMap = [backupSpotsMap [r; c; d]];
##                endif
##              endfor
##            endfor
##          endfor
##        
##        endif
##      
##      endfor
##    endfor
##  endfor
  [frontierMap, backupSpotsMap] = findFrontierAndNearSpots(expandedObstacleMap);
  frontierCentroidMap = round(mean(frontierMap'))';
  while (isequal(frontierCentroidMap, currentPositionMap) || expandedObstacleMap(frontierCentroidMap(1), frontierCentroidMap(2), frontierCentroidMap(3)) == 2)
    % if centroid is obstacle, move to random spot
    disp('findFrontierCentroid-Centroid is obstacle or current location, moving to random frontier spot');
    frontierCentroidMap = backupSpotsMap(:,round(size(backupSpotsMap, 2)*rand)); 
  endwhile
  disp(['findFrontierCentroid-New centroid: ', num2str(frontierCentroidMap')]);
endfunction
