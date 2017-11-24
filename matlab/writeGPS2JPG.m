function status = writeGPS2JPG(fileName,gps)
% use exiftool.exe to write GPS info into the JPEG file
% specified by fileName
%
exiftool = which('exiftool.exe');
if isempty(exiftool)
    disp('ExifTool not available:');
    disp('Please download from,')
    disp('   http://www.sno.phy.queensu.ca/~phil/exiftool/')
    disp('or make sure that the installed exiftool.exe is on your Matlab path')
    beep
    status =1;
    return
else
    lat = [' -gpslatitude=',num2str(abs(gps.lat)),' '];
    if gps.lat > 0
        latRef = ['-gpslatituderef=N '];
    else
         latRef = ['-gpslatituderef=S '];
    end
    lon = ['-gpslongitude=',num2str(abs(gps.lon)),' '];
    if gps.lon > 0
        lonRef = ['-gpslongituderef=E '];
    else
         lonRef = ['-gpslongituderef=W '];
    end   
    command = ['"' exiftool '"',lat,latRef,lon,lonRef,fileName] ;
    [status, junk] = system(command); 
    [status,meta] = system(['"' exiftool '"' [' ',fileName]]);
    
end

