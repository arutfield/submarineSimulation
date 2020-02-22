% mapEnvironment - submarine will map entire environment to the best of its
%                  ability
%  inputs:
%   fullMap - information of the simulated full map with no unknowns
%   resolution - map resolution
%  outputs:
%   success - if mapping was able to finish successfully
%   finalMap - map after exploration is complete
%   lastPoint - last location of the submarine
%   totalTime - time sub took moving (processing time irrelevant)
function [success, finalMap, lastPoint, totalTime] = mapEnvironment(fullMap, resolution)
  success = false;
  loadSubmarineSpecifications;
  submarineDimensions = [submarineLength submarineHeight, submarineWidth];
  origin = zeros(3,1);
finalMap = generateUnknownMap(fullMap, origin, submarineDimensions,...
 submarineLightDistance, resolution);
[a, submarineHandles] = plotKnownMap(finalMap, resolution, []);
disp('mapEnvironment-Finding expanded obstacles map');
expandedObstaclesMap = generateExpandedObstaclesMap(finalMap, origin, submarineDimensions, resolution, submarineMaximumDepth);
plotKnownMap(expandedObstaclesMap, resolution, []);
count=0;
figure(a, 'position', get(0,"screensize"));
if (size(fullMap,3) > 1)
  view([30 -30]);
endif
totalTime=0;
sizeProduct = prod(size(fullMap));
proportionKnown = length(find(finalMap != 0))/sizeProduct;
unReachableSpotsMap = [];
while proportionKnown < 1
  centroidMap = findFrontierCentroid(finalMap, expandedObstaclesMap, convertCoordinateToMap(origin, finalMap, resolution));
  if (centroidMap(1) == -1 && centroidMap(2) < 0 && centroidMap(3) < 0)
    disp(['mapEnvironment-no frontier left']);
    break;
  endif
  wavePathMap=[];
  if (centroidMap(1) != -2)
    nextPoint = convertMapToCoordinate(centroidMap, finalMap, resolution);
    disp(['mapEnvironment-generating wavefront path']);
    wavePathMap = generateWavefrontPath(origin, nextPoint, expandedObstaclesMap, resolution);
    disp(['mapEnvironment-wavefront path generated']);
  endif
  if (isempty(wavePathMap))
    [~, backupSpotsMap] = findFrontierAndNearSpots(expandedObstaclesMap);
    disp(['mapEnvironment-no path found. Looking at Frontier spaces. ', num2str(size(backupSpotsMap, 2)), ' spots to check']);
    for v=1:size(backupSpotsMap, 2)
      % check if spot has been checked before
      alreadyChecked=false;
      
      for b=1:size(unReachableSpotsMap,2)
        if (unReachableSpotsMap(1,b) == backupSpotsMap(1,v) &&...
          unReachableSpotsMap(2,b) == backupSpotsMap(2,v) &&...
          unReachableSpotsMap(3,b) == backupSpotsMap(3,v))
          alreadyChecked=true;
          break;
        endif
      endfor
      if (alreadyChecked)
        continue;
      endif

      nextPoint = convertMapToCoordinate(backupSpotsMap(:,v), expandedObstaclesMap, resolution);
      wavePathMap = generateWavefrontPath(origin, nextPoint, expandedObstaclesMap, resolution);      
      if (!isempty(wavePathMap))
        disp(['mapEnvironment-navigating to frontier point ', num2str(nextPoint'), ' instead']);
        break;
      else 
        disp(['mapEnvironment-no path to frontier point ', num2str(nextPoint')]);
        unReachableSpotsMap = [unReachableSpotsMap backupSpotsMap(:,v)];
        continue;
      endif
    endfor
    if (isempty(wavePathMap))
      disp('Ran out of frontier spots. Finished mapping');
      disp(['mapEnvironment-total time: ', num2str(totalTime)]);
      return;
    endif
  endif
  [finalMap, expandedObstaclesMap, figureHandle2D, movementTime, lastPoint, submarineHandles]=animateWavefrontMovement...
    (finalMap, fullMap, expandedObstaclesMap, wavePathMap, submarineDimensions,...
     submarineLightDistance, resolution, submarineMaximumSpeed, submarineAcceleration, submarineDeceleration, a, submarineHandles, submarineMaximumDepth);
  totalTime = totalTime+movementTime;
  disp(['mapEnvironment-animateWavefront ended at point: ', num2str(lastPoint')]);
  origin = lastPoint;
  count++;
  
  %save(["finalMap_", num2str(count)]);
  disp(['mapEnvironment-count: ', num2str(count)]);
  prevProportion = proportionKnown;
  proportionKnown = length(find(finalMap != 0))/sizeProduct;
  if (prevProportion > proportionKnown)
    error('Data lost. Exiting');
  endif
  disp(['Proportion known so far: ', num2str(proportionKnown)]);
endwhile
 
 disp(['mapEnvironment-total time: ', num2str(totalTime)]);
endfunction

