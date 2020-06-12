function dist = getDistanceMat(coords,mode)
%GETDISTANCE Summary of this function goes here
%   Detailed explanation goes here

%% Load Google API Key
load('GoogleAPIKey.mat')

%%
str_coords = string(coords);
key = gkey;   % Enter the GoogleAPI key
url_dist = "https://maps.googleapis.com/maps/api/distancematrix/"; % outputFormat?parameters'
outputFormat = "json?";
param1 = "origins=";
param2 = "destinations=";
param3 = "key=";
param4 = "mode=";
if isempty(mode)
    mode = "driving";
end
%% Compute Distance
str_dist = strcat(url_dist,outputFormat,param1,str_coords(1,1),",",...
            str_coords(1,2),"&",param2,str_coords(2,1),",",str_coords(2,2),...
            "&",param4,mode,"&",param3,key);
tempdistdat = webread(str_dist);
%dist_strct = jsondecode(tempdistdat);
dist = tempdistdat.rows.elements.distance.value;
end

