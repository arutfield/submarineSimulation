function [success] = mapEnvironment(fullMap, submarineLocation, resolution)
  success = false;
  loadSubmarineSpecifications;
  submarineDimensions = [submarineLength submarineWidth submarineHeight];


  
  unknownMap = generateUnknownMap(fullMap, submarineLocation, submarineDimensions,...
    submarineLightDistance, resolution);
  unknownMap3DHandle = plotKnownMap(unknownMap3D, resolution, []);
  expandedObstaclesMap = generateExpandedObstaclesMap(unknownMap, submarineLocation,...
  submarineDimensions, resolution);



  [knownMap, figureHandle, totalTime, finalSubPosition] = animateWaveformMovement(knownMap, fullMap,...
    wavefrontPathMap, submarineDimensions, submarineLightDistance, resolution, submarineMaximumSpeed...
    , submarineAcceleration, submarineDeceleration);
endfunction
