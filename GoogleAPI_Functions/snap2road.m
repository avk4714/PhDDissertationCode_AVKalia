function outdata = snap2road(lat,long)
%SNAP2ROAD Summary of this function goes here
%   Detailed explanation goes here

%% Load Google API Key
load('GoogleAPIKey.mat')
%%
url = "https://roads.googleapis.com/v1/snapToRoads?";
param1 = "path=";
param2 = "interpolate=false";
param3 = "key=";
key = gkey;   % Enter the GoogleAPI key


sz = length(lat);
for j = 1:sz
    if ~isnan(lat(j)) && ~isnan(long(j))
        if j == 1
            strlat = string(lat(j));
            strlng = string(long(j));
            str = strcat(strlat,",",strlng);
        else
            strlat = string(lat(j));
            strlng = string(long(j));
            str = strcat(str,"|",strlat,",",strlng);
        end
    end
end

str = strcat(url,param1,str,"&",param2,"&",param3,key);
outdata = webread(str);
%outdata = jsondecode(result);

end

