%           #### Energy Consumption Planner SCRIPT ####
%           #### WRITTEN BY: Aman Ved Kalia        ####
%           #### LAST UPDATED: 06/11/2020          ####
%% GUI for User Origin and Destination Input
% gui.ctrl_1 = uicontrol('style','radiobutton','units','pixels',...
%                 'position',[10,30,50,15],'string','Coordinates');
% gui.ctrl_2 = uicontrol('style','radiobutton','units','pixels',...
%                 'position',[10,30,50,15],'string','Location Name');
gui.prompt = {'[Origin]::Street/Location Name','City','State',...
                '[Destination]::Street/Location Name','City','State'};
gui.dlgtitle = 'Route Input';
gui.dims = [1 60;1 30;1 5;1 60;1 30;1 5];
% gui.defInput = {'45.526835,-122.657945','','',...
%                 '45.712020,-121.516617','',''};
% gui.defInput = {'Mechanical Engineering Building','Seattle','WA',...
%                 'Ira Spring Memorial Trail','North Bend','WA'};
gui.defInput = {'12026 32ND AVE NE','Seattle','WA',...
               'Mechanical Engineering Building','Seattle','WA'};
dlgout = inputdlg(gui.prompt,gui.dlgtitle,gui.dims,gui.defInput);
tempOrigin = strcat(dlgout{1, 1}," ",dlgout{2, 1}," ",dlgout{3, 1});
tempDest = strcat(dlgout{4, 1}," ",dlgout{5, 1}," ",dlgout{6, 1});
if ~isempty(dlgout{2, 1}) && ~isempty(dlgout{3, 1}) && ~isempty(dlgout{5, 1}) && ~isempty(dlgout{6, 1})
    gui.strOrigin = strrep(tempOrigin,' ','+');
    gui.strDest = strrep(tempDest,' ','+');
else
    gui.strOrigin = strrep(tempOrigin,' ','');
    gui.strDest = strrep(tempDest,' ','');
end

tic
%% Google API - Get Directions
[pathCoords, pathLength, pathDuration, pathPolyline] = getDirections(gui.strOrigin,gui.strDest);
    % pathCoords is an N -by- 4 matrix where,
    %   [Column 1]: Start Latitude
    %   [Column 2]: Start Longitude
    %   [Column 3]: End Latitude
    %   [Column 4]: End Longitude
    % pathLength is an N -by- 1 vector where,
    %   [Column 1]: Distance in meters
    % pathDuration is an N -by- 1 vector where,
    %   [Column 1]: Duration in seconds
N = length(pathLength);

% - Make path vector with lat,long as columns
pathVector = zeros([N+1 2]);
for i = 1:N+1
    if i ~= N+1
        pathVector(i,:) = [pathCoords(i,1), pathCoords(i,2)];
    else
        pathVector(i,:) = [pathCoords(i-1,3), pathCoords(i-1,4)];
    end
end

%% Google API - Get Elevation
RESAMPLE_FLAG = 0;  % This flag monitors if resampling is needed for more precision.  
DIST_RES = 50;      % resolution in meters.
SAMPLE_VEC = zeros([N 1]);
SAMPLE_VEC = round(pathLength/DIST_RES);
% -- SAMPLE_VEC Breakdown 
% --- Due to the 100 point query limit, the SAMPLE_VEC values and vector
% --- size is readjusted
% while any(SAMPLE_VEC > 100)
EX_LIM = find(SAMPLE_VEC > 100);
SAMPLE_VEC(EX_LIM) = 100;
% ---
QUERY_COORDS = zeros([2 2]);
QUERY_POLYLINE = pathPolyline;
% --- 
FinalPath.lat = [];
FinalPath.lng = [];
FinalPath.elev = [];

QUERY_TYPE_CHOICE = 'polyline'; % Other option is 'locations'

switch QUERY_TYPE_CHOICE
    case 'locations'
        for i = 1:N
            QUERY_COORDS = [pathCoords(i,1),pathCoords(i,2);
                            pathCoords(i,3),pathCoords(i,4)];
            if i == 1
                [FinalPath.lat, FinalPath.lng, FinalPath.elev] = ...
                getElevation(QUERY_COORDS,QUERY_TYPE_CHOICE,SAMPLE_VEC(i),'path');
            else
                [temp_lat, temp_lng, temp_elev] = ...
                getElevation(QUERY_COORDS,QUERY_TYPE_CHOICE,SAMPLE_VEC(i),'path');
                FinalPath.lat = [FinalPath.lat(1:end-1); temp_lat];
                FinalPath.lng = [FinalPath.lng(1:end-1); temp_lng];
                FinalPath.elev = [FinalPath.elev(1:end-1); temp_elev];
            end  
        end
    case 'polyline'
        for i = 1:N
            if i == 1
                [FinalPath.lat, FinalPath.lng, FinalPath.elev] = ...
                getElevation(QUERY_POLYLINE(i,1),QUERY_TYPE_CHOICE,SAMPLE_VEC(i),'path');
            else
                [temp_lat, temp_lng, temp_elev] = ...
                getElevation(QUERY_POLYLINE(i,1),QUERY_TYPE_CHOICE,SAMPLE_VEC(i),'path');
                FinalPath.lat = [FinalPath.lat(1:end-1); temp_lat];
                FinalPath.lng = [FinalPath.lng(1:end-1); temp_lng];
                FinalPath.elev = [FinalPath.elev(1:end-1); temp_elev];
            end  
        end
end
    
    % Re-Calculate path length between the new Final Path and check if
    % within required limits.
%     SnpdPoints1 = snap2road(FinalPath.lat(1:100,1), FinalPath.lng(1:100,1));
%     SnpdPoints2 = snap2road(FinalPath.lat(101:200,1), FinalPath.lng(101:200,1));
%     SnpdPoints3 = snap2road(FinalPath.lat(201:208,1), FinalPath.lng(201:208,1));
% %     SZ_FinalPath = length(FinalPath.lat);
%     temp_PathLen = zeros([SZ_FinalPath-1 1]);
%     for i = 2:SZ_FinalPath
%         coords = [FinalPath.lat(i-1,1), FinalPath.lng(i-1,1);...
%             FinalPath.lat(i,1), FinalPath.lng(i,1)];
%         temp_PathLen(i-1,1) = getDistanceMat(coords,'driving');
%     end
    
    
% end

%% Google API - Snap to Road (multiple requests)

MAX_PATH_LEN = 100;
N_FINALPATH = length(FinalPath.lat);
ctr = 1;
while(ctr < N_FINALPATH)
    if (N_FINALPATH - ctr + 1) > MAX_PATH_LEN
        snappedData = snap2road(FinalPath.lat(ctr:(ctr - 1 + MAX_PATH_LEN)),...
            FinalPath.lng(ctr:(ctr - 1 + MAX_PATH_LEN)));
    else
        snappedData = snap2road(FinalPath.lat(ctr:N_FINALPATH),...
            FinalPath.lng(ctr:N_FINALPATH));
    end
    SNPD_LEN = length(snappedData.snappedPoints);
    if ctr == 1
        for k = 1:SNPD_LEN
            SnappedPath.lat(k,1) = snappedData.snappedPoints(k).location.latitude;
            SnappedPath.lng(k,1) = snappedData.snappedPoints(k).location.longitude;
        end
    else
        for k = 1:SNPD_LEN
            tempSnpd.lat(k,1) = snappedData.snappedPoints(k).location.latitude;
            tempSnpd.lng(k,1) = snappedData.snappedPoints(k).location.longitude;
        end
        SnappedPath.lat = [SnappedPath.lat; tempSnpd.lat];
        SnappedPath.lng = [SnappedPath.lng; tempSnpd.lng];
    end
    ctr = ctr + MAX_PATH_LEN;
end

N_SNPDPATH = length(SnappedPath.lat);
%% Google API - Get Distance
 % - need to work on this
%{
DIST_QUERY = zeros([2 2]);
pathDist = zeros([N_FINALPATH 1]);
for j = 2:N_FINALPATH
    DIST_QUERY(1,:) = [FinalPath.lat(j-1), FinalPath.lng(j-1)];
    DIST_QUERY(2,:) = [FinalPath.lat(j), FinalPath.lng(j)];
    pathDist(j) = pathDist(j-1) + getDistanceMat(DIST_QUERY,"walking");
end
%}
 %% Get elevation and distance for the snapped points
snpd_coords = [SnappedPath.lat SnappedPath.lng];
[~,~,SnappedPath.elev] = getElevation(snpd_coords,'locations',1,'multipoint');
SnappedPath.segdist = zeros([length(snpd_coords) 1]);
for i = 2:length(snpd_coords)
    SnappedPath.segdist(i,1) = getDistanceMat([snpd_coords(i-1,:); snpd_coords(i,:)],'driving');
end
SnappedPath.elev = medfilt1(SnappedPath.elev,10); 
SnappedPath.segdist = medfilt1(SnappedPath.segdist,10);     % 10th Order - Median Filtering
SnappedPath.totdist = cumsum(SnappedPath.segdist);

%% Calculate road grade percentage
SnappedPath.grade = zeros([length(SnappedPath.elev) 1]);
SnappedPath.grade(2:end) = ((SnappedPath.elev(2:end) - SnappedPath.elev(1:end-1))./SnappedPath.segdist(2:end)) * 100;
SnappedPath.grade = medfilt1(SnappedPath.grade,10);

%% Google API - Get Speed and Generate Speed Trace
avgPathSpd_mps = pathLength./pathDuration;
% Initialize output vector
gmapSpeedTrace.time_s = 0;
if length(avgPathSpd_mps) == 1
    gmapSpeedTrace.spd_mps = avgPathSpd_mps;
    gmapSpeedTrace.dist_m = 0;
else
    gmapSpeedTrace.spd_mps = avgPathSpd_mps(1);
    gmapSpeedTrace.dist_m = 0;
end

% Loop
ctr = 1;
for k = 1:N
    if k == 1
        gmapSpeedTrace.time_s = [gmapSpeedTrace.time_s; pathDuration(k)];
        gmapSpeedTrace.spd_mps = [gmapSpeedTrace.spd_mps; avgPathSpd_mps(k)];
        gmapSpeedTrace.dist_m = [gmapSpeedTrace.dist_m; pathLength(k)];
    else
        gmapSpeedTrace.time_s = [gmapSpeedTrace.time_s; gmapSpeedTrace.time_s(end) + 0.01; gmapSpeedTrace.time_s(end) + pathDuration(k)];
        gmapSpeedTrace.spd_mps = [gmapSpeedTrace.spd_mps; avgPathSpd_mps(k); avgPathSpd_mps(k)];
        gmapSpeedTrace.dist_m = [gmapSpeedTrace.dist_m; gmapSpeedTrace.dist_m(end); gmapSpeedTrace.dist_m(end) + pathLength(k)];
    end
end


toc 
%% Plotting

dataTime = string(datetime);

% figure(1)
figure;
ax(1) = subplot(2,2,1);
plot(SnappedPath.lng,SnappedPath.lat,'.b','MarkerSize',10)
plot_google_map
hold on
plot(FinalPath.lng,FinalPath.lat,'.g','MarkerSize',10)
plot_google_map
plot(pathVector(:,2),pathVector(:,1),'.r','MarkerSize',15)
plot_google_map
title(dataTime)
xlabel('Longitude')
ylabel('Latitude')
hold off


% figure(2)
% plot(gmapSpeedTrace.time_s, gmapSpeedTrace.spd_mps, 'linewidth', 2)
% %hold on
% %plot(FinalPath.elev
% grid on
% xlabel('Duration [seconds]')
% ylabel('Average Speed [m/s]')
% title(dataTime)
% makePublishable(0)

% figure(3)
%yyaxis left
% % ax(2) = subplot(2,2,2);
% plot(gmapSpeedTrace.dist_m * 0.001, gmapSpeedTrace.spd_mps, 'linewidth', 2)
% ylabel('Average Speed [m/s]')
% %yyaxis right
% %plot(pathDist * 0.000621371, FinalPath.elev * 3.28084, 'linewidth', 1.5)
% %ylabel('Elevation (above Sea Level) [ft]')
% grid on
% xlabel('Distance [km]')
% title(dataTime)
% makePublishable(0)

% figure(4)
ax(2) = subplot(2,2,2);
yyaxis left
plot(SnappedPath.totdist * 0.001, SnappedPath.elev, 'linewidth', 2)
ylabel('Elevation (above Sea Level) [m]]')
yyaxis right
plot(SnappedPath.totdist * 0.001, SnappedPath.grade, 'linewidth', 1.5)
ylabel('Road Grade [%]')
grid on
xlabel('Distance [km]')
title(dataTime)
legend('Road Elevation','Road Grade')

% makePublishable(0)

%% Save Drive Trace for Simulation
t_decimation = 1;       % 1 = 1 second, 10 = 0.1 second
CUSTOM_STRCT_NAME = [];
pt1 = char(dataTime);
CUSTOM_STRCT_NAME = strcat(string(pt1(4:6)),string(pt1(1:2)),...
    string(pt1(8:11)),string(pt1(13:14)),string(pt1(16:17)),...
    string(pt1(19:20)));

% Metadata section
temp.metadata.origin = tempOrigin;
temp.metadata.destination = tempDest;
temp.metadata.datetime = dataTime;

% Drive Trace data section
temp.time_s(:,1) = linspace(gmapSpeedTrace.time_s(1),...
    gmapSpeedTrace.time_s(end),(gmapSpeedTrace.time_s(end) * t_decimation) + 1);
temp.spd_mph = interp1(gmapSpeedTrace.time_s,gmapSpeedTrace.spd_mps,temp.time_s) * 2.2369 ;
temp.dist_mi = interp1(gmapSpeedTrace.time_s,gmapSpeedTrace.dist_m,temp.time_s) * 0.000621371;

% Additional data
temp.elev_m = interp1(SnappedPath.totdist,SnappedPath.elev,(temp.dist_mi * 1609.34));
temp.grade_pct = interp1(SnappedPath.totdist,SnappedPath.grade,(temp.dist_mi * 1609.34));

% Randomize drive trace
[rand_time_s,rand_speed_mph] = randomizeDrive(temp.time_s,temp.spd_mph,0.25,5,'limit','normal');
% sigma = 0.5 <- old

temp.rand_spd_mph = rand_speed_mph;

eval([char(CUSTOM_STRCT_NAME),' = temp;'])

% figure(5)
ax(3) = subplot(2,2,3);
plot(gmapSpeedTrace.time_s, gmapSpeedTrace.spd_mps, 'linewidth', 2)
hold on
plot(rand_time_s, rand_speed_mph * 0.44704, 'linewidth', 2)
grid on
xlabel('Duration [seconds]')
ylabel('Average Speed [m/s]')
title(dataTime)
% makePublishable(0)

%% Plot Power and Energy
[P_calc, E_calc] = genEnergyConsMap(temp);
ax(4) = subplot(2,2,4);
yyaxis left
plot(temp.dist_mi * 1.60934, P_calc*0.001,'-','linewidth', 2)
ylabel('Estimated Power Demand [kW]')
yyaxis right
plot(temp.dist_mi * 1.60934, E_calc*0.001,'-','linewidth', 2)
ylabel('Estimated Energy Demand [kWh]')
xlabel('Distance [km]')
grid on
legend('Power','Energy')

%% Save data
% if ismac
%     pname = "/Users/amankalia/Documents/MATLAB/DocResWork/Simulation_Models/PreDrive_DP_Optimization/RouteSelectorApp/Google_Drive_Traces/";
% elseif ispc
%     pname = "C:\Users\Aman-Home\Documents\MATLAB\DocResWork\Simulation_Models\PreDrive_DP_Optimization\RouteSelectorApp\Google_Drive_Traces\";
% end
% fname = strcat(CUSTOM_STRCT_NAME,'.mat');
% cname = strcat(pname,fname); 
% save(cname,CUSTOM_STRCT_NAME)

% clear temp





