function mapLocation = convertCoordinateToMap(coordinate, map, resolution)
  %resolution = 0.5;

  twoDimensions = false;
  if (size(map,3) < 2)
    twoDimensions = true;
  endif
  offsets = [size(map, 1)/2; size(map, 2)/2; size(map,3)/2];
  mapLocation = [round(offsets(1)+0.5-coordinate(2)/resolution);...
  round(offsets(2)+0.5+coordinate(1)/resolution); round(1-coordinate(3)/resolution)];
  %for 5 c, 6 r
  %x    c
  %1  5
  %-1  1
  %0   3
  
  %y    r
  % 0.25  3
  %-1.25  6
  % -0.25 4
  
  
  %z coord    map
  % 0            1
  % -0.5         2
  % -1.5         4
  % -2.5         6
  
  
  %if (twoDimensions)
 %   mapLocation(3) = 1;
 % endif
  
endfunction
