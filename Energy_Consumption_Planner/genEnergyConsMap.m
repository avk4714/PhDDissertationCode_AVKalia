function [P_dem, E_dem] = genEnergyConsMap(DTParam)
%GENENERGYCONSMAP Summary of this function goes here
%   Detailed explanation goes here
%% Vehicle Parameters
VehMass = 2012;           % 1852 + 160 <- driver
rl_a = 23;                % vehParams.rl_a = 23;
rl_b = 0.1;               % vehParams.rl_b = 0.21;
rl_c = 0.002;             % 0.005 vehParams.rl_c = 0.01953;
L_aux = 520;
g = 9.81;

for ii = 1:length(DTParam.spd_mph)
 temp_P_dem(ii,1) = (((((rl_c * (DTParam.spd_mph(ii))^2)) +...
        (rl_b * DTParam.spd_mph(ii)) +...
        (rl_a)) * 4.448) + (VehMass * g * sin(DTParam.grade_pct(ii)/100))) * (DTParam.spd_mph(ii) * 0.447);
end
%% Adding Auxiliary Load Power
P_dem = temp_P_dem + L_aux;

%% Energy Map
E_dem = cumsum(P_dem/3600);

%% Plot the values
% figure;
% plot(DTParam.dist_mi * 1.60934, P_dem * 0.001, '-')
% xlabel('Distance [km]')
% ylabel('Estimated Power Demand [kW]')
% grid on
% makePublishable(0)
% 
% figure;
% plot(DTParam.dist_mi * 1.60934, E_dem * 0.001, '-')
% xlabel('Distance [km]')
% ylabel('Estimated Energy Demand [kWh]')
% grid on
% makePublishable(0)

end

