function [trapezoidalTrajectory, t_time, distanceProportions]= generateTrapezoidalTrajectory(startPoint, endPoint, maxSpeed, acceleration)
  %sample 100 Hz
  frequency = 100;
  vi=0;
  vf=0;
  halfwayPoint = 0.5*(endPoint-startPoint);
  %vf^2 = vi^2 + 2ad

  %figure out distance proportions
  magnitudeDistance = norm(endPoint-startPoint);
  for v=1:3
    distances(v,:) = endPoint(v)-startPoint(v);
  endfor

  halfPointSpeedConstantAcceleration = sqrt(vi^2+acceleration*magnitudeDistance);
  if (halfPointSpeedConstantAcceleration > maxSpeed)
    % needs to be trapezoidal
    timeToApproachMaxSpeed=(halfPointSpeedConstantAcceleration - vi)/acceleration;
    maxSpeedTime = (maxSpeed - vi)/acceleration;
    distanceWhenReachingMaxSpeed = 0.5 * acceleration * maxSpeedTime^2;
    constantVelocityDistance = magnitudeDistance - distanceWhenReachingMaxSpeed*2;
    constantVelocityTime = constantVelocityDistance / maxSpeed;
    roundedTime = floor((maxSpeedTime*2+constantVelocityTime)*frequency)/frequency;
    t_time = 0:1/frequency:roundedTime;
    trapezoidalTrajectory = zeros(3, length(t_time));
    
    for k=t_time
        index = round(k*frequency+1);
        if (k < maxSpeedTime)
          xi = 0;
          vi = 0;
          t = k;
          distanceProportions(index) = xi+(vi*t+0.5*acceleration*t^2)/magnitudeDistance;
          
        else
          if (k > maxSpeedTime + constantVelocityTime)
            t = k - maxSpeedTime - constantVelocityTime;
            xi = distanceWhenReachingMaxSpeed + constantVelocityDistance;
            vi = maxSpeed;
            distanceProportions(index) = (xi+vi*t+0.5*-acceleration*t^2)/magnitudeDistance;
          else
            xi = distanceWhenReachingMaxSpeed;
            t = k - maxSpeedTime;
            distanceProportions(index) = (xi+maxSpeed*t)/magnitudeDistance;
          endif
          
        endif
        trapezoidalTrajectory(:,index) =  distances*distanceProportions(index) + startPoint;
    endfor    
  else
    % can be triangular
    halfwayTime=(halfPointSpeedConstantAcceleration - vi)/acceleration;
    roundedTime=floor(halfwayTime*2*frequency)/frequency;
    t_time = 0:1/frequency:roundedTime;
    trapezoidalTrajectory = zeros(3, length(t_time));
    localAcceleration = acceleration;
    xi=0;
    for k=t_time
        index = round(k*frequency+1);
        if (k > halfwayTime)
          vi = halfPointSpeedConstantAcceleration;
          localAcceleration = -acceleration;
          xi = 0.5;
          k = k-halfwayTime;
        endif
        distanceProportions(index) = xi+(vi*k+0.5*localAcceleration*k^2)/magnitudeDistance;
        trapezoidalTrajectory(:,index) =  distances*distanceProportions(index) + startPoint;
    endfor
  endif
endfunction
