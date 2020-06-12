function spdLim = getSpeedLimits(pathVector)
%GETSPEEDLIMITS Summary of this function goes here
%   Detailed explanation goes here
%% Load Google API Key
load('GoogleAPIKey.mat')

%% Function Body

key = gkey;   % Enter the GoogleAPI key
url_dist = "https://roads.googleapis.com/v1/speedLimits?"; % outputFormat?parameters'
param1 = "path=";
param2 = "key=";

%% Form Path String
sz = length(pathVector);
for j = 1:sz
    if j == 1
        strlat = string(pathVector(j,1));
        strlng = string(pathVector(j,2));
        str = strcat(strlat,",",strlng);
    else
        strlat = string(pathVector(j,1));
        strlng = string(pathVector(j,2));
        str = strcat(str,"|",strlat,",",strlng);
    end
end
%% Compute Direction
str_spdLim = strcat(url_dist,param1,str,...
            "&",param2,key);
spdLim = webread(str_spdLim);

end

