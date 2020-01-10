function speedVector = measureSpeed(trajectory)
  speedVector = zeros(1, size(trajectory,2)-1);
  for (k=1:size(trajectory,2)-1)
    speedVector(k)=norm(trajectory(:,k+1)-trajectory(:,k))*100;    
  endfor
endfunction
