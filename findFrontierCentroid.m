function [frontierCentroidMap, frontierMap] = findFrontierCentroid(knownMap, expandedObstacleMap, currentPositionMap=zeros(3,1))
  [frontierMap, backupSpotsMap] = findFrontierAndNearSpots(knownMap);
  if (isempty(frontierMap))
    frontierCentroidMap=-ones(3,1);
    return
  endif
  frontierCentroidMap = round(mean(frontierMap'))';
  if (isequal(frontierCentroidMap, currentPositionMap) || expandedObstacleMap(frontierCentroidMap(1), frontierCentroidMap(2), frontierCentroidMap(3)) == 2)
    % if centroid is obstacle, move to random spot
    
    disp('findFrontierCentroid-Centroid is obstacle or current location, setting invalid flag');
    frontierCentroidMap(1) = -2; 
  endif
  disp(['findFrontierCentroid-New centroid: ', num2str(frontierCentroidMap')]);
endfunction
