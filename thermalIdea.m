inToM = 0.0254;
%kinematic information
dt = 0.0001;
a1 = 0.83*9.8;   % acceleration for first part of run
a2 = -1*2.9785*9.8; % deceleration
t1 = 15.75;    % time accelerating
t2 = 4.14;  % time decelerating
v = 0;       % init velocity
L = 2600; %preload applied to wheel (N)

%material properties
c = 2300;   %specific heat of wheel
k = 892898.37;  % spring constant of wheel, in kg/m   
displacement = L/k;  %displacmenet of wheel due to preload, meters
OR = 4*inToM; % outer radius of wheel (m)
IR = 3.5*inToM; % inner radius of wheel
w = 4*inToM; % tread width (m)
density_tread = 1190.236; %kg/m^3
volume_tread = 0.000192;    %m^3
mass_tread = density_tread*volume_tread;    %.228 kg

% For the drive wheel
wheel_mass = 3.08;           % mass of hub/rim kg
total_mass_wheel = wheel_mass + mass_tread;  %11.77lbs
te = zeros(1,200001);   % matrix of energy rate
tv = zeros(1,200001);   % matrix of velocities
tt = zeros(1,200001);   % matrix of time
ttemp = zeros(1,200001);
lbs_to_kg = 0.453592;
Temp_init = 80;         % init temp of wheels is 80F
curr_temp = Temp_init;    
r = 2.90796660635*inToM;    % radius of gyration
I = total_mass_wheel*r^2;     % moment of inertia of drive wheel
sum = 0;                   
for t = 0:dt:ceil((t1+t2))
    %determine if accelerating or decelerating
   if(t > t1)
       a = a2;
   else
       a = a1;
   end
   % current velocity 
   v = v+a*dt;
   
   %angular velocity
   omega = v/(2*OR*pi);
   
   e = 0;    
   if(v > 0)
    curr_temp = (sum/(c*mass_tread))*9/5+32 + Temp_init;  %assuming that all E goes into tread
    hr = loss_mod_value(curr_temp)/(sqrt(loss_mod_value(curr_temp)^2 + storage_mod_value(curr_temp)^2));
    e = .5*hr*I*omega^3+2*.5*k*hr*(2*displacement)^2*omega; % J/s = KE/sec + PE/sec
    ttemp(round(t/dt+1)) = curr_temp;
    tv(round(t/dt+1)) = v;
    te(round(t/dt+1)) = e;
    tt(round(t/dt+1)) = t;
    sum = sum + e*dt;
   end
end
subplot(2,1,1)
plot(tt, ttemp);
xlabel("Time(sec)");
ylabel("Temp (F)");
title("Temp vs. Time");

subplot(2,1,2)
plot(tv, ttemp);
xlabel("Velocity (m/s)");
ylabel("Temp (F)");
title("Temp vs. Velcoity");

final_temp = curr_temp;
fprintf('The final temp of the drive wheel is %f F\n', final_temp);