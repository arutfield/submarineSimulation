% generateExpandedObstaclesMap - create version of map where sub is one space
%                                and obstacles are expanded to size of sub
%  inputs:
%   map - known map to convert
%   submarineLocation - location of submarine
%   submarineDimensions - dimensions of submarine
%   resolution - map resolution
%   maxDepth - maximum allowed depth (default=-1, meaning none)
%  outputs:
%   expandedObstaclesMap - map where obstacles are expanded and sub is one space
function expandedObstaclesMap = generateExpandedObstaclesMap(map, submarineLocation, submarineDimensions, resolution, maxDepth=-1)
  mapSizes = [size(map, 1) size(map, 2) size(map, 3)];
  expandedObstaclesMap = zeros(mapSizes);
  submarineLocationMap = convertCoordinateToMap(submarineLocation, map, resolution);
  for r=1:mapSizes(1)
    for c=1:mapSizes(2)
      for d=1:mapSizes(3)
        if (map(r,c,d) == 1 || map(r,c,d) == 3)
          expandedObstaclesMap(r,c,d)=1;
        endif
      endfor
    endfor
  endfor
  scale = 1/(resolution*2);
  expandedObstaclesMap(submarineLocationMap(1), submarineLocationMap(2), submarineLocationMap(3)) = 3;
  % add known obstacles
  for r=1:mapSizes(1)
    for c=1:mapSizes(2)
      for d=1:mapSizes(3)
        spot = map(r,c,d);
        if (spot==2)
          rowRange_min = r-round(submarineDimensions(2)*scale);
          if (rowRange_min < 1)
            rowRange_min = 1;
          endif
          rowRange_max = r+round(submarineDimensions(2)*scale);
          if (rowRange_max > mapSizes(1))
            rowRange_max = mapSizes(1);
          endif
          colRange_min = c-round(submarineDimensions(1)*scale);
          if (colRange_min < 1)
            colRange_min = 1;
          endif
          colRange_max = c+round(submarineDimensions(1)*scale);
          if (colRange_max > mapSizes(2))
            colRange_max = mapSizes(2);
          endif
          depthRange_min = d-round(submarineDimensions(3)*scale);
          if (depthRange_min < 1)
            depthRange_min = 1;
          endif
          depthRange_max = d+round(submarineDimensions(3)*scale);
          if (depthRange_max > mapSizes(3))
            depthRange_max = mapSizes(3);
          endif
          for k=rowRange_min:rowRange_max
            for l=colRange_min:colRange_max
              for m=depthRange_min:depthRange_max
                if (expandedObstaclesMap(k,l,m) != 3)
                  expandedObstaclesMap(k,l,m) = 2;
                endif
              endfor
            endfor
          endfor
        endif
      endfor
    endfor
  endfor
  
  is3D=false;
  if (mapSizes(3) > 1)
    is3D=true;
  endif
  
  lowestPointMap = mapSizes(3)-ceil(submarineDimensions(3)*scale);
  
  maxDepthMap = convertCoordinateToMap([0; 0; -maxDepth], expandedObstaclesMap, resolution);
  
  if (maxDepthMap(3) > 1 && maxDepthMap(3) < lowestPointMap)
    lowestPointMap = maxDepthMap(3);
  endif
  % fill in edges
  for r=1:mapSizes(1)
    for c=1:mapSizes(2)
      for d=1:mapSizes(3)
         if ((r-1) < ceil(submarineDimensions(2)*scale) || r >mapSizes(1)-ceil(submarineDimensions(2)*scale)...
           || (c-1) < ceil(submarineDimensions(1)*scale) || c >mapSizes(2)-ceil(submarineDimensions(1)*scale)...
           || d >lowestPointMap)
           expandedObstaclesMap(r,c,d) = 2;
         endif
      endfor
    endfor
  endfor
  
  
endfunction
