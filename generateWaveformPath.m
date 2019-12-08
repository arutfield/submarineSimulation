function path = generateWaveformPath(startPoint, finishPoint, map, resolution)
  pointMap = zeros(size(map));
  twoDimensions = false;
  if size(map,3)== 0
    twoDimensions = true;
  endif
  startPointMap = convertCoordinateToMap(startPoint, map, resolution);
  finishPointMap = convertCoordinateToMap(finishPoint, map, resolution);
  if (map(startPointMap(1), startPointMap(2), startPointMap(3))==2)
    error(['start point is an obstacle']);
  endif
  if (map(finishPointMap(1), finishPointMap(2), finishPointMap(3))==2)
    error(['finish point is an obstacle']);
  endif
  pointMap(startPointMap(1), startPointMap(2), startPointMap(3)) = -1;
  pointMap(finishPointMap(1), finishPointMap(2), finishPointMap(3)) = 1;
  % set obstacles on point map
  for v=1:size(map,1)
    for k=1:size(map,2)
      for l=1:size(map,3)
        if map(v,k,l) == 2
          pointMap(v,k,l)=-3;
        endif
      endfor
    endfor
  endfor
  
  pointsToExpand = finishPointMap;
  success = false;
  while (!success)
   focusPoint = pointsToExpand(:,1);
   score = pointMap(focusPoint(1), focusPoint(2), focusPoint(3))+1;
   for v=-1:1
         if focusPoint(1)+v < 1 || focusPoint(1)+v > size(pointMap,1)
           continue;
         endif
     for k=-1:1
         if focusPoint(2)+k < 1 || focusPoint(2)+k > size(pointMap,2)
           continue;
         endif
       for l=-1:1
         if focusPoint(3)+l < 1  || focusPoint(3)+l > size(pointMap,3)
           continue;
         endif
         if pointMap(focusPoint(1)+v, focusPoint(2)+k, focusPoint(3)+l) == -1
           success = true;% found way by waveform
           pointsToExpand = []; %clear points
           break;
         else
         % set this point's score if not already set and add to points to look through
         if pointMap(focusPoint(1)+v, focusPoint(2)+k, focusPoint(3)+l) == 0
           pointMap(focusPoint(1)+v, focusPoint(2)+k, focusPoint(3)+l) = score;
           pointsToExpand = [pointsToExpand [focusPoint(1)+v; focusPoint(2)+k; focusPoint(3)+l]];
         endif
         endif
       endfor
     endfor
   endfor
   % make sure some points are left and remove the current point since you're done with it
   if size(pointsToExpand,2) < 2
     break;
   endif
   pointsToExpand = pointsToExpand(:,2:end);
  endwhile 

  % if failed, return empty path
  path = [];
  if (!success)
    return;
  endif

  path = startPointMap;
  currentPointMap = startPointMap;
  bestSpotValue=prod(size(map));

  while (currentPointMap(1) != finishPointMap(1)...
    || currentPointMap(2) != finishPointMap(2)...
    || currentPointMap(3) != finishPointMap(3))
    %get path
    nextSpot = zeros(3,1);
    edited=false;
    % iterate through neighboring points
    for r=-1:1
      if currentPointMap(1)+r < 1 || currentPointMap(1)+r > size(pointMap,1)
           continue;
      endif
      for c=-1:1
        if currentPointMap(2)+c < 1 || currentPointMap(2)+c > size(pointMap,2)
           continue;
        endif
        for d=-1:1
          if currentPointMap(3)+d < 1 || currentPointMap(3)+d > size(pointMap,3)
           continue;
          endif
          if norm([r; c; d]) == 0
            continue; % skip current point
          endif
          pointToCheck = currentPointMap + [r; c; d];
          if  pointMap(pointToCheck(1), pointToCheck(2), pointToCheck(3)) < 1
            continue;
          endif
          if (pointMap(pointToCheck(1), pointToCheck(2), pointToCheck(3)) < bestSpotValue)...
            && (pointMap(pointToCheck(1), pointToCheck(2), pointToCheck(3)) < pointMap(currentPointMap(1), currentPointMap(2), currentPointMap(3))...
            || pointMap(currentPointMap(1), currentPointMap(2), currentPointMap(3)) == -1)
            bestSpotValue = pointMap(pointToCheck(1), pointToCheck(2), pointToCheck(3));
            nextSpot = pointToCheck;
            edited = true;
          endif
        endfor
      endfor
    endfor
    if (edited)
      path = [path nextSpot];
    endif
    currentPointMap = nextSpot;
 %   breakCount++;
 %   if (breakCount > 1000)
 %     return;
 %   endif
  endwhile
  
endfunction
