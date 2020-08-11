function [Longitude, Latitude, name]= computeposition (Eph,esec, pos)

%%PARAMETERS OF THE SATELITE TO CALCULATE THE ORBIT
t=esec; %aCTUAL TIME
name=Eph(pos,1); %NAME OF SATELITE
eccentricity=Eph(pos,3); %ECCENTRICITY OF THE ORBIT
Toa=Eph(pos,4); %TIME OF APPLICATION
i0=Eph(pos,5); %ORBIT INCLINATION
Sqra=Eph(pos,7); %SQUARE ROOT OF THE MAJOR SEMI AXIS
w=Eph(pos,9); %ARGUMENT OF THE PERIGEE
M0=Eph(pos,10); %MEAN ANOMALY AT TOA

%FIXED PARAMETERS
G=6.67384*10^(-11); %GRAVIATIONAL CONSTANT
M=5.972*10^24; %EARTH MASS

Tk=t-Toa; %TIME BETWEEN ACTUAL TIME AND TOA

a=(Sqra)^2;%SEMI MAJOR AXIS

n=((G*M)/(a^3))^(1/2);%MEAN MOTION 

Mk=M0+n*Tk;%MEAN ANOMALY

%ECCENTRIC ANOMALY (CALCULATE BY ITERATIONS)
i=1;
Ek=[Mk];%CREATE VECTOR EK AND EK(0)=MK
Dif=1; %ENSURE IT ENTERS THE BUCLE
while (Dif>10^(-8))
    Ek2=Mk+eccentricity*sin(Ek(i)); %CALCULATE THE NEXT EK
    Ek=[Ek,Ek2]; %ADD EK TO VECTOR
    i=i+1;
    Dif=abs(Ek(i)-Ek(i-1));
end
Ek=Ek(i); %GET LAST EK OF THE VECTOR (GOOD ONE)

%TRUE ANOMALY
vk=2*atan((((1+eccentricity)/(1-eccentricity))^(1/2))*tan(Ek/2)); %GET VK FROM THE TANGENT (IN THE PAPER WE GET SIN AND COS AND FROM HERE WE TAKE THE TAN) 

uk=vk+w;%ARGUMENT OF LATITUDE

rk=a*(1-(eccentricity*cos(Ek)));%ORBIT RADIUS

%LONGITUDE OF ASCENDING NODE
Omega0=Eph(pos,8);
Omega01=Eph(pos,6);
Omegae=7.2921151467*(10^-5);
OmegaK=Omega0+Omega01*Tk-Omegae*t;

%X AND Y IN THE ORBITAL PLANE
Xp=rk*cos(uk);
Yp=rk*sin(uk);

%FINAL ECEF COODINATES
X=Xp*cos(OmegaK)-Yp*cos(i0)*sin(OmegaK);
Y=Xp*sin(OmegaK)+Yp*cos(i0)*cos(OmegaK);
Z=Yp*sin(i0);

%%TRANSFORMS FROM ECEF TO LLA IN AN OTHER FUNCTION
[Latitude,Longitude]= transformeceftolla(X,Y,Z);

end

