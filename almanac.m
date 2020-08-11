% Compute current time and date and download almanac (if necessary)

function[baseweek, esec, NS, Eph] = almanac(dayoffset, hh, mm)	% OPTIONAL to override current time: dayoffset (goes back in time for an integer number of days within current year), hour (in UTC time), minute

ToAlist = [061440, 147456, 233472, 319488, 405504, 503808, 589824];		% list of possible ToA (secs.) within the GPS week according to Celestrak web page
timelapse = 3600;									% time interval in seconds (starting from NOW) for which the almanac should be valid

% Find GPS time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/

unixepoch = 2440587.5;                              % JD at unix epoch: 0h (UTC) 1/1/1970

ntime = clock();									% Matlab and clock() give local time
YYYY = ntime(1);
unixmillis = java.lang.System.currentTimeMillis;  % milliseconds from unix epoch
JD = unixepoch + unixmillis / 1000 / 86400;       % Julian Date now in UTC

if (nargin > 0)										% OVERRIDE CURRENT TIME
  df = (hh + mm / 60) / 24;
  J = round(JD) - 0.5;								% JD at last midnight
  JD = J - dayoffset + df;
end

gpsepoch = 2444244.5;                               % JD at GPS epoch: 0h (UTC) 6/1/1980
leapseconds = 18;                                   % leap seconds added to UTC since the GPS epoch. Currently (19/2/2019) 18
gpst = JD - gpsepoch + leapseconds / 86400;         % GPS time (accounting for the leap seconds introduced to UTC time since the GPS epoch)
gpsw = fix(gpst / 7);                               % GPS week
gpstw = gpsw * 7;                                   % GPS time (in days) at week epoch
gpstime = 86400 * (gpst - gpstw);                   % elapsed seconds from last week epoch
roll = fix(gpsw / 1024);                            % number of gps week rollovers that have happened (first rollover: 23:59:47 (UTC) 21/8/1999)
gpsw = mod(gpsw, 1024);

fprintf('current GPS week number = %4.0f (%4.0f + %2.0f rolls)\n', gpsw + 1024, gpsw, roll);
fprintf('elapsed seconds from GPS week epoch until now = %010.3f\n\n', gpstime);

% Download current GPS almanac
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/
limit = 7200;										% obsolescence limit of the ephemeris (secs.)
baseurl = ['http://celestrak.com/GPS/almanac/YUMA/', num2str(YYYY), '/almanac.yuma.week'];
baseweek = gpsw;
esec = gpstime;

for(i = 1:10)
   j = mod(i - 1, 7) + 1;
   if (j < i)
      baseweek = gpsw + 1;
      esec = gpstime - 7 * 86400;
   end
   if (esec + timelapse >= ToAlist(j) + limit)
      continue
   else
      sufix = sprintf('%04.0f.%06.0f', baseweek, ToAlist(j));
      break
   end
end

url = [baseurl sufix '.txt'];					% build complete URL to download almanac
filename = ['almanac_week_' sufix '.txt'];		% build file name for almanac
if (~ exist(filename, 'file'))
   urlwrite(url, filename);                     % download current almanac and store it with filename
end
fid = fopen(filename, 'r');						% read ephemeris from almanac

for (NS = 0:31)									% currently the almanac contains 31 satellites, from PRN-01 to PRN-32, but PRN-04 is missing!
  [head, count] = fscanf(fid, '%c', 45);		% read label
  if (count == 0) break; end;
  for (i = 1:13)
    fscanf(fid, '%c', 25);
    [Eph(NS + 1, i), count] = fscanf(fid, '%f');
  end
end

fclose(fid);
end

