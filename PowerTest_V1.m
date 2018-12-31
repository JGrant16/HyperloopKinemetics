% P = dE/dt where E = 1/2*mv^2
% P = m*v*a --> a = 1/(mv)*P(v)
% Using the Power vs. RPM chart on Emrax, .45 gear ratio and r = 4in of
% drive wheel, used excel to get P(v) = -0.04818951*v^3 + 4.61333247*v^2 + 
% 968.412449*v
% Now, a = 1/(m)*(-0.04818951)*v^2 + 4.61333247*v^ + 
% 968.412449 where m= 120kg. a1,a2,a3 represent the coefficient divided by
% the mass

%solving second order differential equation
pod_mass = 120;
a1 = -0.000401579;
a2 = 0.038444437;
a3 = 8.070103742;
max_accel_dist = 900;
breaking_force = pod_mass*5*9.8; % 5 g's 
decel = breaking_force/pod_mass*-1;
tstep = .001;
tspan = linspace(0,20, 20000);
syms y(t)
[V] = odeToVectorField(diff(y, 2) == a1*diff(y)^2+a2*diff(y)+a3);
M = matlabFunction(V,'vars', {'t','Y'});
[t1, y1] = ode45(M,tspan,[0 0]); %init position and velocity are 0

while(true)
%acceleration
max_vel = 0;
max_vel_time = 0;
for i = 1:20000 
   if (y1(i,1) > max_accel_dist)
      max_vel = y1(i,2);
      max_vel_time = t1(i,1);
      break;
   end
end
accel_time = t1(1:i,1);
position1 = y1(1:i,1);
velocity1 = y1(1:i,2);

%breaking
decel_time = zeros(10000,1);
position2 = zeros(10000,1);
velocity2 = zeros(10000,1);
position2(1,1) = max_accel_dist;
velocity2(1,1) = max_vel;
decel_time(1,1) = max_vel_time;
for j = 2:10000
    decel_time(j,1) = decel_time(j-1,1) + tstep;
    velocity2(j,1) = velocity2(j-1,1) + decel*tstep;
    position2(j,1) = position2(j-1,1) + velocity2(j-1,1)*tstep + 0.5*decel*tstep^2;
    if (velocity2(j,1) < 0)
        break;
    end
end
position2 = position2(1:j,1);
velocity2 = velocity2(1:j,1);
decel_time = decel_time(1:j,1);

stop_time = decel_time(j,1);
stop_dist = position2(j,1);

if (stop_dist < 1149 || stop_dist > 1151) 
    max_accel_dist = max_accel_dist + 1;
    continue;
else
    break;
end
end

fprintf('Max Velocity is %f m/sec at %f sec\n', max_vel, max_vel_time);
fprintf('Time when velocity is 0 is %f sec at a position of %f meters\n', stop_time, stop_dist);

figure(1)
plot(accel_time, velocity1);
hold on 
plot(decel_time, velocity2);
title('Velocity vs Time');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
hold off

figure(2)
plot(accel_time, position1);
hold on 
plot(decel_time, position2);
title('Position vs Time');
xlabel('Time (s)');
ylabel('Position (m)');
hold off

