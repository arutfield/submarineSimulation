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
plotKnownMap(expandedObstaclesMap, resolution);
count=0;
%a=figure;
figure(a, 'position', get(0,"screensize"));%[500 500, 1000, 1000]);
totalTime=0;
sizeProduct = prod(size(fullMap));
proportionKnown = length(find(finalMap != 0))/sizeProduct;
while proportionKnown < 1
  nextPoint = convertMapToCoordinate(findFrontierCentroid(expandedObstaclesMap, convertCoordinateToMap(origin, finalMap, resolution)), finalMap, resolution);
  disp(['mapEnvironment-generating waveform path']);
  wavePathMap = generateWaveformPath(origin, nextPoint, expandedObstaclesMap, resolution);
  disp(['mapEnvironment-waveform path generated']);
  [finalMap, expandedObstaclesMap, figureHandle2D, movementTime, lastPoint]=animateWaveformMovement...
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

