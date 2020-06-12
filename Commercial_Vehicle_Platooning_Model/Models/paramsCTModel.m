% INTRODUCTION:
% Load this script to get the Conventional Truck Model parameters loaded
% in the workspace. This script generates a structure variable which than
% has values that are used in the Conventional Truck Model. 
% P.S.: Modifications to the data can be made directly in this model for
% future use.
% MADE BY:
% Aman Ved Kalia
%% Vehicle Parameters
CTModel.veh_mass_kg = 35380;            % Gross Weight [kg] = 78000 lbs
CTModel.ld_tire_rad_m = 0.489;          % Loaded Tire Radius [kg]
CTModel.Af_m2 = 10.4;                   % Frontal Area [m^2]
CTModel.Cd_avg = 0.52;                  % Average Coefficient of Drag
CTModel.P_aux_elec = 1200;              % Auxiliary electric power [W]
CTModel.P_aux_mech = 2300;              % Auxilliary mechanical power [W]
CTModel.P_aux_load_frac = 0.5;          % Auxiliary Load fraction

%% Engine Parameters
CTModel.eng_inertia_kgm2 = 4.17;
CTModel.peak_eng_trq_map = [0;1200;1320;1490;1700;1950;2090;2100;2100;...
    2093;2092;2085;2075;2010;1910;1801;1640;1350;910];
CTModel.peak_eng_trq_spd_bpt = [600;750;850;950;1050;1100;1200;1250;1300;...
    1400;1500;1520;1600;1700;1800;1900;2000;2100;2250];
CTModel.peak_eng_pwr_map = CTModel.peak_eng_trq_map .* (CTModel.peak_eng_trq_spd_bpt * 0.1047 * 0.001);
CTModel.mtr_eng_trq_map = [-98;-98;-121;-138;-155;-174;-184;-204;-214;...
    -225;-247;-270;-275;-294;-319;-345;-372;-400;-429];
CTModel.mtr_eng_trq_spd_bpt = [0;600;750;850;950;1050;1100;1200;1250;1300;...
    1400;1500;1520;1600;1700;1800;1900;2000;2100];
load('EPA2018DGENERIC455_data.mat')
CTModel.eng_fuel_map = EPA2018DGENERIC455_fuelMap_gps;
CTModel.eng_trq_map = EPA2018DGENERIC455_trqMap; 
CTModel.eng_map_trq_bpt = EPA2018DGENERIC455_trqbpt_Nm;
CTModel.eng_map_spd_bpt = EPA2018DGENERIC455_spdbpt_rpm;
CTModel.eng_bsfc_map = zeros(size(CTModel.eng_fuel_map));
% Calculate BSFC Map
for i = 1:length(CTModel.eng_map_trq_bpt)
    for j = 1:length(CTModel.eng_map_spd_bpt)
        if isnan(CTModel.eng_fuel_map(i,j))
            CTModel.eng_bsfc_map(i,j) = NaN;
        else
            CTModel.eng_bsfc_map(i,j) = (CTModel.eng_fuel_map(i,j)/...
                (CTModel.eng_map_trq_bpt(i) * CTModel.eng_map_spd_bpt(j) * 0.1047))*3600000;
        end
    end
end

%% Transmission Parameters
CTModel.trns_inertia_kgm2 = 5;
CTModel.gear_ratios = [12.8;9.25;6.76;4.9;3.58;2.61;1.89;1.38;1;0.73];
CTModel.gear_eff = [0.96;0.96;0.96;0.96;0.98;0.98;0.98;0.98;0.98;0.98];
CTModel.fd_ratio = 2.64;

%% Fuel/ Fuel Tank Parameters
CTModel.fuelTankCap_L = 300 * 3.785;            % 300 Gallon Capcity
CTModel.fuelLHV_kwhpkg = 11.83;                  % kWh/kg - Diesel
CTModel.fuelrho_kgpl = 0.846;                   % kg/m3 density
%% Miscellaneous
CTModel.axle_inertia_kgm2 = 360;