% generateTrapezoidalTrajectory - create trajectory with trapezoidal velocity
%                                 shape
%  inputs:
%   startPoint-beginning point
%   endPoint-ending point
%   maxSpeed-maximum allowed speed
%   acceleration-rate of speed increase
%   deceleration-rate of speed decrease
%  outputs:
%   trapezoidalTrajectory - resulting trajectory with 3 dimensions
%   t_time - time vector for trajectory
%   distanceProportions - proportions of distance completed so far (1=end)
function [trapezoidalTrajectory, t_time, distanceProportions]= generateTrapezoidalTrajectory(startPoint, endPoint, maxSpeed, acceleration, deceleration)
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

    maxSpeedTime = (maxSpeed - vi)/acceleration;
    slowToStopTime = maxSpeed/deceleration; %m/s/(m/s^2)
    distanceWhenReachingMaxSpeed = 0.5 * acceleration * maxSpeedTime^2;
    distanceWhenDeceleratingFromMaxSpeed = 0.5 * deceleration * slowToStopTime^2;
    constantVelocityDistance = magnitudeDistance - distanceWhenReachingMaxSpeed - distanceWhenDeceleratingFromMaxSpeed;
  if (constantVelocityDistance > 0)
    % needs to be trapezoidal
    constantVelocityTime = constantVelocityDistance / maxSpeed;
    roundedTime = floor((maxSpeedTime + slowToStopTime + constantVelocityTime)*frequency)/frequency;
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
            distanceProportions(index) = (xi+vi*t+0.5*-deceleration*t^2)/magnitudeDistance;
          else
            xi = distanceWhenReachingMaxSpeed;
            t = k - maxSpeedTime;
            distanceProportions(index) = (xi+maxSpeed*t)/magnitudeDistance;
          endif
          
        endif
        trapezoidalTrajectory(:,index) =  distances*distanceProportions(index) + startPoint;
    endfor    
  else
    % can be triangular-x_m is the point where it starts decelerating
    x_of = magnitudeDistance;
    x_mf = acceleration*x_of/(deceleration + acceleration);
    x_om = x_of - x_mf;
    accelerationTime=sqrt(x_om*2/acceleration);
    decelerationTime=sqrt(x_mf*2/deceleration);
    v_m = acceleration*accelerationTime;
    roundedTime=floor((accelerationTime+decelerationTime)*frequency)/frequency;
    t_time = 0:1/frequency:roundedTime;
    trapezoidalTrajectory = zeros(3, length(t_time));
    localAcceleration = acceleration;
    xi=0;
    for k=t_time
        index = round(k*frequency+1);
        if (k > accelerationTime)
          vi = v_m;
          localAcceleration = -deceleration;
          xi = x_om;
          k = k-accelerationTime;
        endif
        distanceProportions(index) = (xi+vi*k+0.5*localAcceleration*k^2)/x_of;
        trapezoidalTrajectory(:,index) =  distances*distanceProportions(index) + startPoint;
    endfor
  endif
endfunction
