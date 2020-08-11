function plotcompletegroundtrack(filename,Eph,esec,pos)

%PUT THE BACKGROUND MAP
file=fopen(filename,'r'); %OPEN THE FILE WITH THE COORDINATES
Longitudes=[];%CREATE VECTOR OF LONGITUDES FOR ALL POINTS
Latitudes=[]; %CREATE VECTOR OF LATITUDES FOR ALL POINTS
for (i=1:5257) %READ AL THE FILE ROWS
    Longitudes=[Longitudes,str2double(fscanf(file,'%s+ '))]; %IN EVERY ROW PUT THE LONGITUDE AND THE LATITUDE IN THE CORRESPONDING VECTOR
    Latitudes=[Latitudes,str2double(fscanf(file,'%s+ '))];
end

%START FIGURE
figure(1)

sz=7; %SIZE OF THE POINTS
c='y'; %COLOR OF THE POINTS (YELLOW)
scatter(Longitudes,Latitudes,sz,c,'filled') %PUT THE POINTS WITH THEIR COLOR AND SIZE
title (['Complete groundtrack of the satelite ',num2str(Eph(pos,1))]); % PUT THE TITLE TO THE GRAPH
xlim([-180 180]); %LIMITS OF THE GRAPH. BEING LONGITUDE FROM -180 TO 180 AND LATITUDE FROM -90 TO 90 COVERS ALL THE WORLD
ylim([-90 90]);
grid on; %PUTS THE GRID SO IT IS CLEARER WHERE THE SATELITES ARE. CHANGE THE ON TO OFF TO DISABLE THIS.
set(gca,'Color',[0.75 0.75 0.75]) %BACKGROUND IN SMOOTH GREY SO THE POINTS ARE MORE VISIBLE 
hold on %HOLS THE GRAPH MADE UNTIL THIS POINT. WE WILL ADD MORE THINGS LATER (THE SATELITE TRAJECTORY)

%PUT THE SATELITE TRAJECTORY
csat='r'; %COLOR OF THE POINTS
szsat=8; %SIZE OF THE TRAJECTORY POINTS
szsat2=50; %SIZE OF THE POINT OF ACTUAL POSITION
time=esec; %ACTUAL TIME 

for (i=1:288) %288 ITERATIONS BECAUSE THERE ARE 288 PERIODS OF 5 MINUTS IN 24 HOURS
    [Longitude, Latitude, name]= computeposition (Eph,time, pos);%COMPUTE ACTUAL POSITION
    scatter(Longitude,Latitude,szsat,csat,'filled'); %PLOT THE ACTUAL POSITIONS
    hold on %HOLDS FOR THE OTHER POINTS
    if (i==1) %IF IT'S ACTUAL POSITION 
        n=num2str(name); %CONVERT THE NUMBER NAME INTO A STRING
        scatter (Longitude,Latitude, szsat2,csat); %PUTS A BIGGER CIRCLE IN THE ACTUAL POSITION
        text(Longitude+5,Latitude,n); %LABELS THE POINT WITH THE NAME
        hold on
    end
    time=time+300; %INCREASE 5 MINUTES
end
hold off