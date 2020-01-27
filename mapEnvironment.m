function [success, knownMap] = mapEnvironment(fullMap, resolution)
  success = false;
  loadSubmarineSpecifications;
  submarineDimensions = [submarineLength submarineHeight, submarineWidth];
  origin = zeros(3,1);
knownMap = generateUnknownMap(fullMap, origin, submarineDimensions,...
 submarineLightDistance, resolution);
knownMapHandle = plotKnownMap(knownMap, resolution, []);
expandedObstaclesMap = generateExpandedObstaclesMap(knownMap, origin, submarineDimensions, resolution);
plotKnownMap(expandedObstaclesMap, resolution);
nextPoint = findFrontierCentroid(knownMap);
wavePathMap = generateWaveformPath(origin, nextPoint, expandedObstaclesMap, resolution);
a=figure;
figure(a, 'position', get(0,"screensize"));%[500 500, 1000, 1000]);


%set(gcf, 'Position',  [0, 0, 1200, 1200]);
[finalMap, expandedObstaclesMap, figureHandle2D, totalTime]=animateWaveformMovement...
(knownMap, fullMap, expandedObstaclesMap, wavePathMap, submarineDimensions, [],...
 submarineLightDistance, resolution, submarineMaximumSpeed, submarineAcceleration, submarineDeceleration, a);
endfunction

%maxSpeed, acceleration, deceleration, figureHandle
