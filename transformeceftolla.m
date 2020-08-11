function [Lat,Lon] = transformeceftolla(X,Y,Z)
%FROM ECEF To LLA:

%PARAMETERS
a=6378137;
e=0.08181919;
b= sqrt(a^2*(1-e^2));
e1=(((a^2)/(b^2))-1)^(1/2);

%EQUATIONS (ALL THIS EQUATIONS ARE IN THE PAPER, WE JUST FOLLOW THE PAPER INSTRUCTIONS)
r=(X^2+Y^2)^(1/2);
E=((a^2)-(b^2))^(1/2);
F=54*(b^2)*(Z^2);
G=r^2+(1-(e^2))*Z^2-((e^2)*(E^2));
C=((e^4)*F*(r^2))/(G^3);
s=(1+C+((C^2+2*C)^(1/2)))^(1/3);
P=F/(3*((s+(1/s)+1)^2)*(G^2));
Q=(1+(2*(e^4)*P))^(1/2);
r0=(-((P*(e^2)*r)/(1+Q))+(((1/2)*(a^2)*(1+(1/Q)))-((P*(1-e^2)*(Z^2))/(Q*(1+Q)))-(1/2)*P*(r^2)))^(1/2);
U=((Z^2)+((r-(r0*(e^2)))^2))^(1/2);
V=(((Z^2)*(1-(e^2)))+((r-r0*(e^2))^2))^(1/2);
z0=((b^2)*Z)/(a*V);
h=U*(1-((b^2)/(a*V))); %CALCULATED BUT IT IS NOT NEEDED (WE DON'T NEED THE ALTITUDE TO DRAW THE SATELITES)

Latitud=atan((Z+((e1^2)*z0))/r);
Longitud=atan2(Y,X);

Lat=Latitud*(360/(2*pi));%PASS FROM RADIANTS TO DEGREES
Lon=Longitud*(360/(2*pi));%PASS FROM RADIANTS TO DEGREES
