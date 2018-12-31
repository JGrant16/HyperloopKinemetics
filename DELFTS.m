%% Dynamics from Energy Losses through Functional Temperature Solutions
%% Constants
inToM = 0.0254;
lbToN = 4.45;
%% Given Information

%The time step
dt = 0.0001; %s
%Brake deceleration
Bd = 9.8*2.9785; %m/s^2
%Static deflection
d = 0.0178*inToM; %M
%Static load
L = 2600; %N
%Intial temperature
Temp_init = 80; %F
%Pod Mass
PM = 120; %Kg
%% Material Properties

%Specific heat of wheel
c = 2300; %J*(kg*K)
%Spring Constant
k = L/d; %N/m
%% Wheel properties

%Mass of tread
mT = 4.96473952078*lbToN/9.8; %Kg
%Mass of Hub
mW = 6.39368861885*lbToN/9.8; %Kg
%Total mass
m = mT+mW; %Kg
%Radius of Gyration
rg = 2.80977473599*inToM; %M
%Mass moment of inertia
I = m*(rg)^2; %kg*m^2
%Outer radius
r = 4*inToM; %M
%Gear ratio
gr = 0.45;
%% Loop information

% Total time duration. Should be less than 20 seconds, so using 20 as a
% guess
t = 0:dt:20.0099;
l = length(t);
% Keeping track of the acceleration, velocity and displacement
a = zeros(l,1);
v = zeros(l,1);
v(1) = 0.4;
x = zeros(l,1);
x(1) = 15;
temps = zeros(l,1);
%Setting the current temperature to the intial temperature
curr_temp = Temp_init; %F
%Sum of all the total Heat generation rates
sum = 0; %W
for i = 1:l
    %Angular frequency of wheel
    omega = v(i)/(2*pi*r); %Hz
    %Adjusting the current temperature.(The 9/5 is to convert from the 
    %kelvin scale, to the Fahrenheit scale. The normal +32 is ommited, as 
    % it is just a change in temperature)
    curr_temp = (sum/(c*mT))*9/5 + Temp_init; %F
    if(i == 1)
        disp(sum)
        disp(c*mT)
        disp(Temp_init)
        disp(curr_temp)
    end
    %Creating the temperature array
    temps(i) = curr_temp;
    %Finding the Dynamic Hysterisis Ratio
    hr = loss_mod_value(curr_temp)/sqrt(loss_mod_value(curr_temp)^2+storage_mod_value(curr_temp)^2); %Unitless
    %Finding the Heat generation rate, which is Total Energy times Hysteris
    %ratio
    e = 0.5*hr*I*(omega*2*pi)^2*omega+2*hr*k*d.^2*omega;
    %Finding the total energy in the wheel
    sum = sum + e*dt;
    %Finding the acceleration
    %findChangeV(v(i),e,m,gr,r)
    a(i) = findChangeV(v(i),e,PM,gr,r);
    %Using that acceleration to numerically find the change in velocity and
    %displacement
    v(i+1) = a(i)*dt+v(i);
    x(i+1) = v(i)*dt+x(i);
    %Checking to see if we would need to start braking
    if(x(i+1)+(v(i+1))^2/Bd/2 > 1150)
        %Brake
        v_max = v(i+1);
        break;
    end
end
tb = t(i);
tstop = tb+v(i+1)/Bd;
%This loop handles us braking
for j = i:l
    %Angular frequency
    omega = v(j)/(2*pi*r); %Hz
    curr_temp = (sum/(c*mT))*9/5+Temp_init; %F
    temps(j) = curr_temp;
    hr = loss_mod_value(curr_temp)/sqrt(loss_mod_value(curr_temp)^2+storage_mod_value(curr_temp)^2);
    e = 0.5*hr*I*(omega*2*pi)^2*omega+2*hr*k*d.^2*omega;
    sum = sum + e*dt;
    a(j) = -1*Bd;
    if(a(j)*dt+v(j) <= 0)
        break
    end
    v(j+1) = a(j)*dt+v(j);
    x(j+1) = v(j)*dt+x(j);    
end
final_temp = curr_temp
v_max
figure(1)
subplot(2,1,1)
plot(t(1:j),temps(1:j))
xlabel("Time(sec)")
ylabel("Temp (F)")
title("Temp vs. Time")
subplot(2,1,2)
plot(v(1:j),temps(1:j))
xlabel("Velocity (m/s)")
ylabel("Temp (F)")
title("Temp vs. Velocity")
figure(2)
subplot(3,1,1)
plot(t(1:j),x(1:j))
xlabel("Time (sec)")
ylabel("Displacement (M)")
subplot(3,1,2)
plot(t(1:j),v(1:j))
xlabel("Time (sec)")
ylabel("Velocity (M/s)")
subplot(3,1,3)
plot(t(1:j),a(1:j))
xlabel("Time (sec)")
ylabel("acceleration (M/s^2)")