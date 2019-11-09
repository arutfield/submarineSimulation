function wayPoints = generateWayPoints(waveFrontPoints);
  wayPoints = waveFrontPoints(:,1); % add startpoint
  for k=2:size(waveFrontPoints,2)-1
    isWayPoint=false;
    for v=1:3  
      if ((waveFrontPoints(v,k)-waveFrontPoints(v,k-1)) !=...
        (waveFrontPoints(v,k+1)-waveFrontPoints(v,k)))
        wayPoints = [wayPoints waveFrontPoints(:,k)];
        break;
      endif
    endfor
  endfor
  wayPoints = [wayPoints waveFrontPoints(:, size(waveFrontPoints,2))];
endfunction
