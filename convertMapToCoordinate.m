function coordinate = convertMapToCoordinate(mapLocation, map)
    twoDimensions = false;
  if (size(map,3) < 2)
    twoDimensions = true;
  endif
  offsets = [size(map, 1)/2; size(map, 2)/2; size(map,3)/2];
  %mapLocation = [offsets(1)+0.5-coordinate(2);...
  %offsets(2)+0.5+coordinate(1); 0.5-coordinate(3)];
  coordinate = [mapLocation(2)-offsets(2)-0.5;...
  offsets(1)+0.5-mapLocation(1);...
  0.5-mapLocation(3)];
  
  
  
  %for 5 x, 6 y
  %x    c
  %-2  1
  %-1  2
  %0   3
  
  %y    r
  %-2.5  6
  %-1.5  5
  % -0.5 4
  
  
  %z coord    map
  % -0.5         1
  % -1.5         2
  % -2.5         3
  
  
  if (twoDimensions)
    coordinate(3) = 0;
  endif
  
endfunction
