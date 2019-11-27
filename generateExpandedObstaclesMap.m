function expandedObstaclesMap = generateExpandedObstaclesMap(map, submarineLocation, submarineDimensions, resolution)
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
  expandedObstaclesMap(submarineLocationMap(1), submarineLocationMap(2), submarineLocationMap(3)) = 3;
  % add known obstacles
  for r=1:mapSizes(1)
    for c=1:mapSizes(2)
      for d=1:mapSizes(3)
        spot = map(r,c,d);
        if (spot==2)
          rowRange_min = r-submarineDimensions(2);
          if (rowRange_min < 1)
            rowRange_min = 1;
          endif
          rowRange_max = r+submarineDimensions(2);
          if (rowRange_max > mapSizes(1))
            rowRange_max = mapSizes(1);
          endif
          colRange_min = c-submarineDimensions(1);
          if (colRange_min < 1)
            colRange_min = 1;
          endif
          colRange_max = c+submarineDimensions(1);
          if (colRange_max > mapSizes(2))
            colRange_max = mapSizes(2);
          endif
          depthRange_min = d-submarineDimensions(3);
          if (depthRange_min < 1)
            depthRange_min = 1;
          endif
          depthRange_max = d+submarineDimensions(3);
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
  
endfunction
