% findFrontierCentroid - find centroid of frontier for known map
%  inputs:
%   knownMap - current known map
%   expandedObstacleMap - known map converted into expanded obstacles
%   currentPositionMap - submarine current position (default=zeros(3,1))
%  outputs:
%   frontierCentroidMap - centroid of frontier in map frame
%   frontierMap - list of frontier locations in map frame
function [frontierCentroidMap, frontierMap] = findFrontierCentroid(knownMap, expandedObstacleMap, currentPositionMap=zeros(3,1))
  [frontierMap, backupSpotsMap] = findFrontierAndNearSpots(knownMap);
  if (isempty(frontierMap))
    frontierCentroidMap=-ones(3,1);
    return
  endif
  frontierCentroidMap = round(mean(frontierMap'))';
  if (isequal(frontierCentroidMap, currentPositionMap) || expandedObstacleMap(frontierCentroidMap(1), frontierCentroidMap(2), frontierCentroidMap(3)) == 2)
    % if centroid is obstacle, set as invalid. Frontier spot will be chosen later
    
    disp('findFrontierCentroid-Centroid is obstacle or current location, setting invalid flag');
    frontierCentroidMap(1) = -2; 
  endif
  disp(['findFrontierCentroid-New centroid: ', num2str(frontierCentroidMap')]);
endfunction
