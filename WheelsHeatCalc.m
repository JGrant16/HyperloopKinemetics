% E = k*v/(R^(5/3))*t*L^(4/3)*(s/w)^(4/3)
%

inToM = 0.0254;

%kinematic information

dt = 0.0001;

a1 = 0.83*9.8;

a2 = -1*2.9785*9.8;

t1 = 15.75;

t2 = 4.14;

%material properties

c = 2300;

k = 0.19;



R = 4*inToM; %radius of wheel (m)

L = 2600; %load on wheel (N)

s = 1*inToM; %tread thickness (m)

w = 4*inToM; %tread width (m)



% For the drive wheel

mtD = 0.358;

mD = 6.62;

E1 = 0;

v = 0;

te = zeros(1,200001);

tv = zeros(1,200001);

tt = zeros(1,200001);

tE1 = zeros(1,200001);

for t = 0:dt:ceil((t1+t2))

   if(t > t1)

       a = a2;

   els

       a = a1;

   end

   v = v+a*dt;

   if(v > 0)

       E1 = E1 + k*v/(R^(5/3))*dt*L^(4/3)*(s/w)^(4/3);

       tE1(round(t/dt+1)) = E1;

       E = k*v/(R^(5/3))*dt*L^(4/3)*(s/w)^(4/3);

   end

   tv(round(t/dt+1)) = v;

   te(round(t/dt+1)) = E;

   tt(round(t/dt+1)) = t;

end

%Tempertures of different masses

tE = sum(te*dt);

T = tE/(mD*c);

%T3 = (E/(mD*c)-273.15)*9/5+32

%T4 = E/(mtD*c)



%%

hr = .4;  % Unitless

te = zeros(1,200001);

tv = zeros(1,200001);

tt = zeros(1,200001);

v = 0;

m = 11.76670394047*0.453592;

r = 2.90796660635*0.0254;

I = m*r^2;

%I = 61.56446309755*0.00863097484*0.453592; % mass moment of interia

for t = 0:dt:ceil((t1+t2))

   if(t > t1)

       a = a2;

   else

       a = a1;

   end

   v = v+a*dt;

   omega = v/(2*r*pi);

   e = 0;

   if(v > 0)

       e = hr*0.5*I*omega^3;

   end

   tv(round(t/dt+1)) = v;

   te(round(t/dt+1)) = e;

   tt(round(t/dt+1)) = t;

end

plot(tv,te)

a = sum(te*dt);

(a(end)/(c*mD))*9/5+32