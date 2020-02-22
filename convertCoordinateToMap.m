% convertCoordinateToMap - convert coordinate location to map/grid domain
%  inputs:
%   coordinate - location to convert
%   map - map to use as reference
%   resolution - resolution of map
%  outputs:
%   mapLocation - coordinate converted into map/grid domain
function mapLocation = convertCoordinateToMap(coordinate, map, resolution)
  offsets = [size(map, 1)/2; size(map, 2)/2; size(map,3)/2];
  mapLocation = [round(offsets(1)+0.5-coordinate(2)/resolution);...
  round(offsets(2)+0.5+coordinate(1)/resolution); round(1-coordinate(3)/resolution)];
  
endfunction
