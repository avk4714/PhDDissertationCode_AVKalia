function [legCoords, legDist, legDuration, legPolyline] = getDirections(origin,destination)
% [legCoords, legDist, legDuration, legPolyline]
%GETDIRECTIONS Uses Google API to obtain directions.
%   This function uses the Origin and Destination coordinates to obtain
%   "Driving" directions from Google API.

%% Function Test Case Parameter
% origin = "12026+32ND+AVE+NE+Seattle+WA";
% destination = "Rhein+Haus+Seattle+Seattle+WA";

%% Load Google API Key
load('GoogleAPIKey.mat')

%% Function Body

key = gkey; % Enter the GoogleAPI key
url_dist = "https://maps.googleapis.com/maps/api/directions/"; % outputFormat?parameters'
trafficModelType = "best_guess";
depTime = "now";
outputFormat = "json?";
param1 = "origin=";
param2 = "destination=";
param3 = "key=";
param4 = "traffic_model=";
param5 = "departure_time=";
%% Compute Direction
str_dist = strcat(url_dist,outputFormat,param1,origin,...
            "&",param2,destination,"&",param5,depTime,"&",...
            param4,trafficModelType,"&",param3,key);
tempdirdat = webread(str_dist);
%dir_strct = jsondecode(tempdirdat);
legLength = length(tempdirdat.routes.legs.steps);
legCoords = zeros([legLength 4]);
legDist = zeros([legLength 1]);
legDuration = zeros([legLength 1]);
legPolyline = {};
for i = 1:legLength
    if legLength ~= 1
        legCoords(i,1) = tempdirdat.routes.legs.steps{i, 1}.start_location.lat;
        legCoords(i,2) = tempdirdat.routes.legs.steps{i, 1}.start_location.lng;
        legCoords(i,3) = tempdirdat.routes.legs.steps{i, 1}.end_location.lat;
        legCoords(i,4) = tempdirdat.routes.legs.steps{i, 1}.end_location.lng;
        legDist(i,1) = tempdirdat.routes.legs.steps{i, 1}.distance.value;   % unit is meters
        legDuration(i,1) = tempdirdat.routes.legs.steps{i, 1}.duration.value;     % unit is seconds
        legPolyline(i,1) = struct2cell(tempdirdat.routes.legs.steps{i, 1}.polyline);     % string value
    else
        legCoords(i,1) = tempdirdat.routes.legs.steps.start_location.lat;
        legCoords(i,2) = tempdirdat.routes.legs.steps.start_location.lng;
        legCoords(i,3) = tempdirdat.routes.legs.steps.end_location.lat;
        legCoords(i,4) = tempdirdat.routes.legs.steps.end_location.lng;
        legDist(i,1) = tempdirdat.routes.legs.steps.distance.value;   % unit is meters
        legDuration(i,1) = tempdirdat.routes.legs.steps.duration.value;     % unit is seconds
        legPolyline(i,1) = struct2cell(tempdirdat.routes.legs.steps.polyline);     % string value
    end
end
end

