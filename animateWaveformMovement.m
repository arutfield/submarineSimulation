function [knownMap, expandedObstaclesMap, figureHandle, totalTime, finalSubPosition, oldSubHandles, success] = animateWaveformMovement(knownMap, fullMap, expandedObstaclesMap, wavefrontPathMap, submarineDimensions, subHandles, flashlightRange, resolution, maxSpeed, acceleration, deceleration, figureHandle, oldSubHandles, maximumDepth);
  success=true;
  twoDimensions=true;
  if size(knownMap,3)>1
    twoDimensions=false;
  endif
  dimensions=size(knownMap);
  %disp('animateWaveformMovement-plotting known map');
  %[~, oldSubHandles]=plotKnownMap(knownMap, resolution, subHandles, figureHandle);
  %set(gca, 'Color', 'k');
  %hold on;
  %disp('animateWaveformMovement-known map plotted');
  axisVector=[];
  for d=1:2
    axisVector = [axisVector -dimensions(3-d)/2*resolution dimensions(3-d)/2*resolution];
  endfor
  if !twoDimensions
    axisVector = [axisVector -dimensions(3)*resolution 0];
  endif
  
  axis(axisVector);
  
  totalTime = 0;
  prevPositionMap = [-1 -1 -1]';
  for v=1:size(wavefrontPathMap,2)
    wavefrontPath(:,v)=convertMapToCoordinate(wavefrontPathMap(:,v), knownMap, resolution);
  endfor
  for k=2:size(wavefrontPath,2)
    [trajectory, time]=generateTrapezoidalTrajectory(wavefrontPath(:,k-1),...
    wavefrontPath(:,k), maxSpeed, acceleration, deceleration);
    trajectoryMap = zeros(3, size(trajectory,2));
    for s=1:size(trajectory,2)
      trajectoryMap(:,s) = convertCoordinateToMap(trajectory(:,s), knownMap, resolution);
    endfor

    % check if waypoint still clear. Otherwise, don't move
    if (!waypointStillClear(expandedObstaclesMap, trajectoryMap, 1))
      %disp(['Obstacle found, stopping between waypoints']);
      finalSubPosition = subPosition;
      success=false;
      disp(['Leaving between waypoints, final position: ', num2str(finalSubPosition')]);
      finalSubPositionMap=convertCoordinateToMap(finalSubPosition, knownMap, resolution);
      disp(['Map position: ', num2str(finalSubPositionMap')]);
      return;
    endif
    
    
    % move through that trajectory 
    for m=1:size(trajectory,2)
      subPosition = trajectory(:,m);
      subPositionMap = trajectoryMap(:,s);
      if (isequal(subPositionMap, prevPositionMap))
        continue;
      endif

      [knownMap, expandedObstaclesMap, newLocations ]=updateMap(fullMap, knownMap, subPosition, submarineDimensions, flashlightRange, resolution, maximumDepth);
      [oldSubHandles]=plotUpdatedMap(knownMap, resolution, dimensions, twoDimensions, newLocations, oldSubHandles, figureHandle);

      
      % check if waypoint still clear. Otherwise, slow to stop and return
      if (!waypointStillClear(expandedObstaclesMap, trajectoryMap, m))
        disp(['Obstacle found, stopping early']);
        if (m > 1)
          currentSpeed = norm([trajectory(:,m)-trajectory(:,m-1)])/0.01;
        else
          if (m < size(trajectory,2)-1)
            currentSpeed = norm([trajectory(:,m+1)-trajectory(:,m)])/0.01;
          else
            error(['Trajectory has only one point']);
          endif
        endif
        originalPosition = subPosition;
        originalDestination = wavefrontPath(:,k);
        % slow to stop
        [stoppingTrajectory, time]=generateStopTrajectory(originalPosition, originalDestination, currentSpeed, deceleration);
        for v=1:size(stoppingTrajectory,2)
          subPosition = stoppingTrajectory(:,v);
          subPositionMap = convertCoordinateToMap(subPosition, knownMap, resolution);
          if (isequal(subPositionMap, prevPositionMap))
            continue;
          endif
          [knownMap,  expandedObstaclesMap, newLocations ]=updateMap(fullMap, knownMap, subPosition, submarineDimensions, flashlightRange, resolution, maximumDepth);
          [oldSubHandles]=plotUpdatedMap(knownMap, resolution, dimensions, twoDimensions, newLocations, oldSubHandles);
          %pause(0.01);
          prevPositionMap = subPositionMap;
          totalTime = totalTime + time(m);
        endfor
        finalSubPosition = subPosition;
        success=false;
        disp(['Leaving early, final position: ', num2str(finalSubPosition'),...
        ', required stopping distance: ', num2str(norm(stoppingTrajectory(:,1)-stoppingTrajectory(:,end)))]);
        disp(['Map position: ', num2str(subPositionMap')]);
        return;
      endif
      pause(0.01);
      
      prevPositionMap = subPositionMap;
    endfor
    totalTime = totalTime + time(end);
  endfor
  finalSubPosition = subPosition;
endfunction


function [submarineHandles]=plotUpdatedMap(knownMap, resolution, dimensions, twoDimensions, newLocations, oldSubmarineHandles, figureHandle)

% move sub
if (!twoDimensions)
  for k=1:length(oldSubmarineHandles)
    delete(oldSubmarineHandles(k));
  endfor
endif
subIndex=1;
submarineHandles = [];
shiftValue = 0.5*resolution;

%disp(['plotUpdatedMap-newLocations size-', num2str(length(newLocations))]);
subCell=0;
% filter new locations
newLocations = unique(newLocations', "rows", "first");
newLocations = newLocations';
for k = 1:size(newLocations, 2)
      y=newLocations(1,k);
      x=newLocations(2,k);
      z=newLocations(3,k);
      %disp(['point to convert: ', num2str([y x z])]);
      value = knownMap(y, x, z);
      if (value == 0)
        continue;
      endif
      coordinatePoint = convertMapToCoordinate([y x z]', knownMap, resolution);
      x_c=coordinatePoint(1);
      y_c=coordinatePoint(2);
      z_c=coordinatePoint(3);
      if twoDimensions
        x_vect = [x_c-shiftValue x_c-shiftValue x_c+shiftValue x_c+shiftValue];
        y_vect = [y_c-shiftValue y_c+shiftValue y_c+shiftValue y_c-shiftValue];
        switch value
          case 1
            fill(x_vect, y_vect, 'w', 'EdgeColor', 'None');
          case 2
            fill(x_vect, y_vect, 'r', 'EdgeColor', 'None');
          case 3
            fill(x_vect, y_vect, 'g', 'EdgeColor', 'None');
            %disp(['plotUpdatedMap: sub cell:', num2str(newLocations(:,k)')]);
            subCell++;
          otherwise
            error(["unknown value: ", num2str(value)]);
          end
      else
        switch value
          case 1
            drawCube([x_c y_c z_c resolution/2 0 0 0], 'FaceColor', 'w', 'EdgeColor', 'None');
          case 2
            drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'r', 'EdgeColor', 'None');
          case 3
            submarineHandles(subIndex) = drawCube([x_c y_c z_c resolution 0 0 0], 'FaceColor', 'g', 'EdgeColor', 'None');
            subIndex++;
          otherwise
            error(["unknown value: ", num2str(value)]);
          end
      endif
endfor
%disp(['plotUpdatedMap-number of sub cells: ', num2str(subCell)]);
endfunction


function [stoppingTrajectory, time]=generateStopTrajectory(originalPosition,...
  originalDestination, currentSpeed, deceleration);
  frequency = 100;
  fullDistanceLeft = norm([originalPosition-originalDestination]);  
  %vf^2=vi^2+2ax
  distanceToStop = -currentSpeed^2/(2*-deceleration);
  proportionOfDistance = distanceToStop/fullDistanceLeft;
  time = distanceToStop*2/currentSpeed;
  distances = [originalDestination - originalPosition];
  t_time = 0:1/frequency:time;
  stoppingTrajectory = zeros(3, length(t_time));
  for k=t_time
    index = round(k*frequency+1);
    delta_x = currentSpeed*k - 0.5*deceleration*k^2;
    proportion = delta_x/fullDistanceLeft;
    stoppingTrajectory(:,index) = distances*proportion + originalPosition;
  endfor
  
endfunction


function [clearSpot] = waypointStillClear(expandedObstaclesMap, trajectoryMap, m)
  clearSpot = true;
  trajectorySize = size(trajectoryMap, 2);
  for k=m:trajectorySize
    if (expandedObstaclesMap(trajectoryMap(1,k), trajectoryMap(2,k), trajectoryMap(3,k)) == 2)
      clearSpot = false;
      return;
    endif
  endfor
endfunction