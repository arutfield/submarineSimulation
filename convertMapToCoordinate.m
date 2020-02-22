% convertMapToCoordinate - convert map location to coordinate frame
%  inputs:
%   mapLocation - location to convert
%   map - map to convert from
%   resolution - resolution of map
%  outputs:
%   coordinate - coordinate of given map location
function coordinate = convertMapToCoordinate(mapLocation, map, resolution)
  offsets = [size(map, 1)/2; size(map, 2)/2; size(map,3)/2];
  coordinate = [resolution*(mapLocation(2)-offsets(2)-0.5);...
  resolution*(offsets(1)+0.5-mapLocation(1));...
  resolution*(1-mapLocation(3))];  
endfunction
