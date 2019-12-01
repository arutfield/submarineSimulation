function [figureHandle, totalTime] = animateWaveformMovement(knownMap, fullMap, wavefrontPathMap, submarineDimensions, flashlightRange, resolution, maxSpeed, acceleration, deceleration);
  figureHandle = 0;
  totalTime = 0;
  for v=1:size(wavefrontPathMap,2)
    wavefrontPath(:,v)=convertMapToCoordinate(wavefrontPathMap(:,v), knownMap, resolution);
  endfor
  for k=2:size(wavefrontPath,2)
    [trajectory, time]=generateTrapezoidalTrajectory(wavefrontPath(:,k-1),...
    wavefrontPath(:,k), maxSpeed, acceleration, deceleration);
    for m=1:size(trajectory,2)
      subPosition = trajectory(:,m);
      updateMap(fullMap, knownMap, subPosition, submarineDimensions, flashlightRange, resolution);
      %figureHandle=plotKnownMap(knownMap, resolution, figureHandle);
      pause(0.01);
      if (m<size(trajectory,2) || k<size(wavefrontPath,2)-1)
        set(figureHandle, 'Visible', 'off');
      endif
    endfor
    totalTime = totalTime + time(end);
  endfor

endfunction
