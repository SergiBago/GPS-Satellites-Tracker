# GPS-Satellites-Tracker
Program developed with Matlab that downloads the almanacs of the GPS satellites from the Celestrack website, and calculates their current and future positions

The program uses the data of current time, eccentricity of the orbit, application time, inclination of the orbit, root of the semi-major axis, periogeal argument and the mean anomaly in the TOA, included in the almanacs, to calculate the current position of each of the satellites. With these data, the position is calculated in ECEF (Earth Centered Earth Fixed) coordinates of the satellite, and then it's transformed from ECEF to LLA (Latitude Longitude Altitude) coordinates, to later draw the positions on the map.

We can get the position of each satellite in a period between now and the next hour, with intervals of 5 minutes. We can also see the complete orbit of a selected satellite over 24 hours, also in 5 minute intervals.

To choose which satellite we want the complete orbit of, we must open the Main.m file and change the pos parameter, choosing the number of satellite we want:

![Satelite Pos Parameter](https://github.com/SergiBago/GPS-Satellites-Tracker/blob/master/Images/Show%20Pos%20Parameter.PNG)

Once the satellite is chosen, we obtain its complete orbit:

![Satelite Complete Groundtrack](https://github.com/SergiBago/GPS-Satellites-Tracker/blob/master/Images/Complete%20GroundTrack.PNG)

And also all the constellation satelites positions:

![Satelite Complete Groundtrack](https://github.com/SergiBago/GPS-Satellites-Tracker/blob/master/Images/Constellation%20Image.PNG)
