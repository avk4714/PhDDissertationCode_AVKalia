function [lat,long,elev] = getElevation(coords,inpType,sample,type)
%GETELEVATION Summary of this function goes here
%   Detailed explanation goes here
%% Load Google API Key
load('GoogleAPIKey.mat')
%% Use Inputs
key = gkey;   % Enter the GoogleAPI key
url_elev = "https://maps.googleapis.com/maps/api/elevation/";
outputFormat = "json?";
param1 = "origins=";
param2 = "destinations=";
param3 = "key=";
param4 = "locations=";
param5 = "path=";
param6 = "samples=";
%%
[r,c] = size(coords);
if ((r ~= 1) || (r ~= 2)) && (c ~= 2) && inpType == "locations"
    error('Check coords dimensions.Should be [1-by-2] or [2-by-2]')
else
    switch type
        case 'single'
            if r ~= 1 && inpType == "locations"
                error('Incorrect coords dimensions for the chosen type.')
            else
                switch inpType
                    case 'locations'
                        arg = string(coords);
                        str_elev = strcat(url_elev,outputFormat,param4,arg(1,1),",",...
                        arg(1,2),"&",param3,key);
                        tempelevdat = webread(str_elev);
                        %elev_strct = jsondecode(tempelevdat);
                        elev = tempelevdat.results.elevation;
                        lat = tempelevdat.results.location.lat;
                        long = tempelevdat.results.location.lng;
                    case 'polyline'
                        arg = string(coords);
                        str_elev = strcat(url_elev,outputFormat,param4,"enc:",arg,...
                        "&",param3,key);
                        tempelevdat = webread(str_elev);
                        %elev_strct = jsondecode(tempelevdat);
                        elev = tempelevdat.results.elevation;
                        lat = tempelevdat.results.location.lat;
                        long = tempelevdat.results.location.lng;
                end
            end
        case 'path'
            if r ~= 2 && inpType == "locations"
                error('Incorrect coords dimensions for the chosen type.')
            else
                switch inpType
                    case 'locations'
                        arg = string(coords);
                        str_elev = strcat(url_elev,outputFormat,param5,arg(1,1),",",...
                        arg(1,2),"|",arg(2,1),",",arg(2,2),"&",param6,string(sample),"&",param3,key);
                        tempelevdat = webread(str_elev);
                        %elev_strct = jsondecode(tempelevdat);
                    case 'polyline'
                        arg = string(coords);
                        str_elev = strcat(url_elev,outputFormat,param5,"enc:",arg,...
                        "&",param6,string(sample),"&",param3,key);
                        tempelevdat = webread(str_elev);
                        %elev_strct = jsondecode(tempelevdat);
                end
                
                for i = 1:sample
                    if tempelevdat.status ~= "INVALID_REQUEST"
                        elev(i,1) = tempelevdat.results(i).elevation;
                        lat(i,1) = tempelevdat.results(i).location.lat;
                        long(i,1) = tempelevdat.results(i).location.lng;
                    else
                        elev(i,1) = NaN;
                        lat(i,1) = NaN;
                        long(i,1) = NaN;
                    end
                end
            end
        case 'multipoint'
            switch inpType
                case 'locations'
                    % Generate the request string 
                    arg = "";
                    for i = 1:length(coords)
                        if i == 1
                            arg = strcat(arg,string(coords(i,1)),",",string(coords(i,2)));
                        else
                            arg = strcat(arg,"|",string(coords(i,1)),",",string(coords(i,2)));
                        end
                    end
                    str_elev = strcat(url_elev,outputFormat,param4,arg,...
                        "&",param3,key);
                    tempelevdat = webread(str_elev);
                    %elev_strct = jsondecode(tempelevdat);
                    for j = 1:length(coords)
                        elev(j,1) = tempelevdat.results(j).elevation;
                        lat(j,1) = tempelevdat.results(j).location.lat;
                        long(j,1) = tempelevdat.results(j).location.lng;
                    end
                case 'polyline'
                    arg = string(coords);
                    str_elev = strcat(url_elev,outputFormat,param4,"enc:",arg,...
                        "&",param3,key);
                    tempelevdat = webread(str_elev);
                    %elev_strct = jsondecode(tempelevdat);
                    for j = 1:length(coords)
                        elev(j,1) = tempelevdat.results(j).elevation;
                        lat(j,1) = tempelevdat.results(j).location.lat;
                        long(j,1) = tempelevdat.results(j).location.lng;
                    end
            end
    end
end

