function [Satelitesinfo]=computeallpositions(Eph,esec)
%COMPUTE ALL THE POSITIONS WITH THE COMPUTEPOSITION FORMULA

Satelitesinfo=zeros(31,3); %CREATES A TABLE TO PUT ALL THE SATELITES INFO
for(i=1:31) %ITERATES TO CALCULATE FOR THE 31 SATELITE
    [Lon,Lat,Name]=computeposition(Eph,esec,i); %USE THE FUNCTION TO CALCULATE THE POSITION OF EACH SATELITE
    Satelitesinfo(i,1)=Name; %PUTS THE NAME IN THE TABLE
    Satelitesinfo(i,2)=Lon; %PUTS THE LONGITUDE IN THE TABLE
    Satelitesinfo(i,3)=Lat; %PUTS THE LATITUDE IN THE TABLE
end
