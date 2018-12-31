function a = findChangeV(v,P_lost,mass,gearRatio,radius)
%fitting coefficents for the emrax power curve
c0 = -186.2; c1 = 269; c2 = -0.6867; c3 = 0.004759; c4 = -0.00001214; c5 = 0.00000000957;
%a constant for the power calculations
c = gearRatio/radius; %1/m
m = mass; % kg
%The power curve of the emrax, for a specific velocity
P_gain = c0+c1.*c.*v+c2.*(v.*c).^2+c3.*(v.*c).^3+c4.*(v.*c).^4+c5.*(v.*c).^5; %W
% Power loss from drag is P = .5*?CAv^3 where ? = .01 m^3/kg at 85F and
% .125psi. C is .1 for a streamlined half body. A ~= 0.12m^2
P_drag = .5*.01*.1*.12*v^3;
P_lost = P_lost + P_drag;
P = P_gain - P_lost; %W
%The acceleration at that velocity/power
a = P./(m.*v); %m/s^2
end

