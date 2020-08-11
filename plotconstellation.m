function plotconstellation(filename,Eph,esec )

%PUT THE BACKGROUND MAP
file=fopen(filename,'r'); %OPEN THE FILE WITH THE COORDINATES
Longitudes=[];%CREATE VECTOR OF LONGITUDES FOR ALL POINTS
Latitudes=[]; %CREATE VECTOR OF LATITUDES FOR ALL POINTS
for (i=1:5257) %READ AL THE FILE ROWS
    Longitudes=[Longitudes,str2double(fscanf(file,'%s+ '))]; %IN EVERY ROW PUT THE LONGITUDE AND THE LATITUDE IN THE CORRESPONDING VECTORS
    Latitudes=[Latitudes,str2double(fscanf(file,'%s+ '))];
end


figure(2) %START THE FIGURE FOR THE PLOT. FIGURE 2 SO MATLAB DOESN'T DELET THE OTHER GRAFIC TO SHOW THIS ONE

sz=7;%SIZE OF THE POINTS
c='y'; %COLOR OF THE POINTS ('Y'=YELLOW)
scatter(Longitudes,Latitudes,sz,c,'filled') %CREATES THE SCATTER PLOT WITH THE POINTS, SIZE, AND COLOR PREVIOSLY DESIGNED. 'FILLED SO THE POINTS ARE FILLED'
title ('Current and future GPS  satelites groundtracks');%TITLE OF THE GRAPH
xlim([-180 180]);%LIMITS OF THE GRAPH. BEING LONGITUDE FROM -180 TO 180 AND LATITUDE FROM -90 TO 90 COVERS ALL THE WORLD
ylim([-90 90]);
grid on; %PUTS THE GRID SO IT IS CLEARER WHERE THE SATELITES ARE. CHANGE THE ON TO OFF TO DISABLE THIS.
set(gca,'Color',[0.75 0.75 0.75]) %BACKGROUND IN SMOOTH GREY SO THE POINTS ARE MORE VISIBLE 
hold on %HOLS THE GRAPH MADE UNTIL THIS POINT. WE WILL ADD MORE THINGS LATER (THE SATELITES)

%%SATELITES 

PA=[1,3,10,11,12,14,17,18,19,20,22,23,24,25,26,31,32]; %THIS ARE FOR SELECTING THE SATELITES COLOR. PA ARE GREEN, NM ARE BLUES AND THE ONES THAT AREN'T PA AND NOT NM ARE RED
NM=[5,6,7,9,13,15,16,21,23,26,27,29,30];

time=esec; %TIMEFOR THE FIRST CALCULATION
for (e=1:12) %12 TIMES BECAUSE ONE HOURE HAS 12 PERIODS OF 5 MINUTES
    [Satelitesinfo]=computeallpositions(Eph,time); %COMPUTE THE POSITIONS OF THE SATELITES FOR EACH TIME
     for (i=1:31) %BUCLE TO DRAW ALL THE SATELITES
           name=(Satelitesinfo(i,1)); %NAME OF THE SATELITE
           colorfound=false; %SELECTING THE COLOR
            for (s=1:length(PA)) %IF IS PA ENTERS THIS SO THE COLOR IS GREEN
                if name==(PA(s))
                    csat=[0 (1/3)+e/20 0]; %SELECTING THE COLOR OF THE SATELITE IN RGB. THE SECOND COMPONENT DEPENDS ON THE ITERATION AS THE CURRENT POSITION WILL BE DARK GREEN COLOR AND FURTHER IT IS CLEARER IT WILL BE
                    colorfound=true; %KNOW IF THE COLOR IS FOUND 
                    break 
                end
            end
             if colorfound==false
                for (s=1:length(NM)) %SAME AS BEFORE BUT WITH THE NON MONITORED SATELITES 
                    if name==(NM(s))
                        csat=[0 e/12 1]; %SAME BUT WITH BLUE
                        colorfound=true;
                        break
                    end
                end
             end
             if colorfound==false
                    csat=[(1/3)+e/20 0 0]; %IF THE SATELITE IS NOT IN THE OTHERS LIST WILL BE RED
             end
            szsat=8; % SIZE OF THE SATELITE
            szsat2=35; %SIZE OF THE BIGER ROUND OF THE SATELITE          
            lon=Satelitesinfo(i,2); %COORDINATES OF THE POINT
            lat=Satelitesinfo(i,3);
            scatter(lon,lat,szsat,csat,'filled'); %DRAW THE SATELITE
            hold on 
            if (e==1) %IF IT IS THE ACTUAL POSITION WE WILL PUT A BIGGER CIRCLE AND A LABEL WITH THE SATELITE NAME
                scatter (lon, lat, szsat2,csat); %DRAW A BIGGER CIRCLE ARROUND THE SATELITE IN THE ACTUAL POSITION
                name=num2str(Satelitesinfo(i,1)); %NAME OF THE SATELITE
                text(lon+2,lat,name,'Color','k'); %LABEL THE SATELITE
                hold on
            end
         end
    time=time+300; %ADD FIVE MINUTES TO THE TIME
end
    
hold off