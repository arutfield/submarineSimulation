function [success, finalMap, lastPoint, totalTime] = mapEnvironment(fullMap, resolution)
  success = false;
  loadSubmarineSpecifications;
  submarineDimensions = [submarineLength submarineHeight, submarineWidth];
  origin = zeros(3,1);
finalMap = generateUnknownMap(fullMap, origin, submarineDimensions,...
 submarineLightDistance, resolution);
[a, submarineHandles] = plotKnownMap(finalMap, resolution, []);
disp('mapEnvironment-Finding expanded obstacles map');
expandedObstaclesMap = generateExpandedObstaclesMap(finalMap, origin, submarineDimensions, resolution);
plotKnownMap(expandedObstaclesMap, resolution, []);
count=0;
%a=figure;
figure(a, 'position', get(0,"screensize"));%[500 500, 1000, 1000]);
totalTime=0;
sizeProduct = prod(size(fullMap));
proportionKnown = length(find(finalMap != 0))/sizeProduct;
unReachableSpotsMap = [];
while proportionKnown < 1
  centroidMap = findFrontierCentroid(finalMap, expandedObstaclesMap, convertCoordinateToMap(origin, finalMap, resolution));
  if (centroidMap(1) < 0 && centroidMap(2) < 0 && centroidMap(3) < 0)
    disp(['mapEnvironment-no frontier left']);
    break;
  endif
  nextPoint = convertMapToCoordinate(centroidMap, finalMap, resolution);
  disp(['mapEnvironment-generating waveform path']);
  wavePathMap = generateWaveformPath(origin, nextPoint, expandedObstaclesMap, resolution);
  disp(['mapEnvironment-waveform path generated']);
  if (isempty(wavePathMap))
    disp('mapEnvironment-no path found. Looking at Frontier spaces');
    [~, backupSpotsMap] = findFrontierAndNearSpots(expandedObstaclesMap);
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
      wavePathMap = generateWaveformPath(origin, nextPoint, expandedObstaclesMap, resolution);      
      if (!isempty(wavePathMap))
        disp(['mapEnvironment-navigating to frontier point ', num2str(nextPoint'), ' instead']);
        break;
      else 
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
  [finalMap, expandedObstaclesMap, figureHandle2D, movementTime, lastPoint, submarineHandles]=animateWaveformMovement...
    (finalMap, fullMap, expandedObstaclesMap, wavePathMap, submarineDimensions, [],...
     submarineLightDistance, resolution, submarineMaximumSpeed, submarineAcceleration, submarineDeceleration, a, submarineHandles);
  totalTime = totalTime+movementTime;
  disp(['mapEnvironment-animateWaveform ended at point: ', num2str(lastPoint')]);
  origin = lastPoint;
  count++;
  
  save(["finalMap_", num2str(count)]);
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

