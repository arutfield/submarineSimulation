function coordinate = convertMapToCoordinate(mapLocation, map, resolution)
  offsets = [size(map, 1)/2; size(map, 2)/2; size(map,3)/2];
  coordinate = [resolution*(mapLocation(2)-offsets(2)-0.5);...
  resolution*(offsets(1)+0.5-mapLocation(1));...
  resolution*(1-mapLocation(3))];
  
  % 3 8 1 -> 2 0.5 0 (6, 7) map offsets (3, 3.5 0)
  
  %for 5 x, 6 y
  %x    c
  %1  5
  %-1  1
  %0   3
  
  %y    r
  %-2.5  6
  %-1.5  5
  % -0.5 4
  
  %z coord    map
  % 0            1
  % -0.5         2
  % -1.5         4
  % -2.5         6
  
  
  %if (twoDimensions)
  %  coordinate(3) = 0;
  %endif
  
endfunction
