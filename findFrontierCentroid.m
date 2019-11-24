function [frontierCentroidMap, frontierMap] = findFrontierCentroid(knownMap)
  frontierMap = [];
  mapSizes = [size(knownMap,1) size(knownMap,2) size(knownMap,3)];
  for r=1:mapSizes(1)
    for c=1:mapSizes(2)
      for d=1:mapSizes(3)
        spot = knownMap(r, c, d);
        if (spot != 0)
          for k=-1:1
            if (r+k < 1 || r+k>mapSizes(1))
              continue;
            endif
            for l=-1:1
              if (c+l < 1 || c+l>mapSizes(2))
                continue;
              endif
              for m=-1:1
                if (d+m < 1 || d+m>mapSizes(3) || (m==0 && l==0 && k==0))
                  continue;
                endif
                if (knownMap(r+k, c+l, d+m) == 0)
                  frontierMap = [frontierMap [(2*r+k)/2; (2*c+l)/2; (2*d+m)/2]];
                endif
              endfor
            endfor
          endfor
        
        endif
      
      endfor
    endfor
  endfor
  frontierCentroidMap = mean(frontierMap')';
  
endfunction
