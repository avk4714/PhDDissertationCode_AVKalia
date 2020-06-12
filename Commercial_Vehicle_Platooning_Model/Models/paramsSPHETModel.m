% INTRODUCTION:
% Load this script to get the Conventional Truck Model parameters loaded
% in the workspace. This script generates a structure variable which than
% has values that are used in the Conventional Truck Model. 
% P.S.: Modifications to the data can be made directly in this model for
% future use.
% MADE BY:
% Aman Ved Kalia
%% Vehicle Parameters
SPHETModel.veh_mass_kg = 35380;            % Gross Weight [kg] = 78000 lbs
SPHETModel.ld_tire_rad_m = 0.489;          % Loaded Tire Radius [kg]
SPHETModel.Af_m2 = 10.4;                   % Frontal Area [m^2]
SPHETModel.Cd_avg = 0.52;                  % Average Coefficient of Drag
SPHETModel.P_aux_elec = 1200;              % Auxiliary electric power [W]
SPHETModel.P_aux_mech = 2300;              % Auxilliary mechanical power [W]
SPHETModel.P_aux_load_frac = 0.5;          % Auxiliary Load fraction

%% Engine Parameters
SPHETModel.eng_inertia_kgm2 = 4.17;
SPHETModel.peak_eng_trq_map = [0;1200;1320;1490;1700;1950;2090;2100;2100;...
    2093;2092;2085;2075;2010;1910;1801;1640;1350;910];
SPHETModel.peak_eng_trq_spd_bpt = [600;750;850;950;1050;1100;1200;1250;1300;...
    1400;1500;1520;1600;1700;1800;1900;2000;2100;2250];
SPHETModel.peak_eng_pwr_map = SPHETModel.peak_eng_trq_map .* (SPHETModel.peak_eng_trq_spd_bpt * 0.1047 * 0.001);
SPHETModel.mtr_eng_trq_map = [-98;-98;-121;-138;-155;-174;-184;-204;-214;...
    -225;-247;-270;-275;-294;-319;-345;-372;-400;-429];
SPHETModel.mtr_eng_trq_spd_bpt = [0;600;750;850;950;1050;1100;1200;1250;1300;...
    1400;1500;1520;1600;1700;1800;1900;2000;2100];
load('EPA2018DGENERIC455_data.mat')
SPHETModel.eng_fuel_map = EPA2018DGENERIC455_fuelMap_gps;
SPHETModel.eng_trq_map = EPA2018DGENERIC455_trqMap; 
SPHETModel.eng_map_trq_bpt = EPA2018DGENERIC455_trqbpt_Nm;
SPHETModel.eng_map_spd_bpt = EPA2018DGENERIC455_spdbpt_rpm;
SPHETModel.eng_bsfc_map = zeros(size(SPHETModel.eng_fuel_map));
% Calculate BSFC Map
for i = 1:length(SPHETModel.eng_map_trq_bpt)
    for j = 1:length(SPHETModel.eng_map_spd_bpt)
        if isnan(SPHETModel.eng_fuel_map(i,j))
            SPHETModel.eng_bsfc_map(i,j) = NaN;
        else
            SPHETModel.eng_bsfc_map(i,j) = (SPHETModel.eng_fuel_map(i,j)/...
                (SPHETModel.eng_map_trq_bpt(i) * SPHETModel.eng_map_spd_bpt(j) * 0.1047))*3600000;
        end
    end
end

%% Transmission Parameters
SPHETModel.trns_inertia_kgm2 = 5;
SPHETModel.gear_ratios = [12.8;9.25;6.76;4.9;3.58;2.61;1.89;1.38;1;0.73];
SPHETModel.gear_eff = [0.96;0.96;0.96;0.96;0.98;0.98;0.98;0.98;0.98;0.98];
SPHETModel.fd_ratio = 2.64;

%% Fuel/ Fuel Tank Parameters
SPHETModel.fuelTankCap_L = 150 * 3.785;            % 150 Gallon Capcity
SPHETModel.fuelLHV_kwhpkg = 11.83;                  % kWh/kg - Diesel
SPHETModel.fuelrho_kgpl = 0.846;                   % kg/m3 density

%% HV Battery Parameters - A123 Battery Cells
load('A123Battery_146_data.mat')
load('ESS_DblPolDat.mat')
SPHETModel.V_cell_nom = 3.2;
SPHETModel.Q_cell_max_Ah = A123_HD_Hyb_ESS.Q_cell_max_Ah;                
SPHETModel.Np = A123_HD_Hyb_ESS.Np;                   
SPHETModel.Ns = A123_HD_Hyb_ESS.Ns;                            
SPHETModel.Nmod = A123_HD_Hyb_ESS.Nmod;
SPHETModel.socbpt = A123_HD_Hyb_ESS.socbpt;
SPHETModel.cellTempbpt_C = A123_HD_Hyb_ESS.cellTempbpt_C;
SPHETModel.DchgCurrLim_10sAvg_A = A123_HD_Hyb_ESS.DchgCurrLim_10sAvg_A;
SPHETModel.ChgCurrLim_10sAvg_A = A123_HD_Hyb_ESS.ChgCurrLim_10sAvg_A;
SPHETModel.DchgCurrLim_cont_A = A123_HD_Hyb_ESS.DchgCurrLim_cont_A;
SPHETModel.ChgCurrLim_cont_A = A123_HD_Hyb_ESS.ChgCurrLim_cont_A;
SPHETModel.batt_R0 = R0;
SPHETModel.batt_R1 = R1;
SPHETModel.batt_R2 = R2;
SPHETModel.batt_C1 = C1;
SPHETModel.batt_C2 = C2;
SPHETModel.batt_socbpt = soc_bpt;

%% Traction Motor Parameters - TM4 SUMO HD3500
SPHETModel.mtr_eff = 0.95;
SPHETModel.n_motors = 1;
load('Dana_HD3500_data.mat')
SPHETModel.peak_mtr_trq_map = HD3500_pktrq_Nm;
SPHETModel.peak_mtr_trq_spdbpt = HD3500_spdbpt_rpm;
SPHETModel.peak_mtr_pwr_map = HD3500_pkpwr_kW;
SPHETModel.cont_mtr_trq_map = HD3500_conttrq_Nm;
SPHETModel.cont_mtr_trq_spdbpt = HD3500_spdbpt_rpm;
SPHETModel.cont_mtr_pwr_map = HD3500_contpwr_kW;
SPHETModel.mtr_regen_pwr_vec = -1 * [0 0.025 0.075 0.15 0.3 0.45 0.6 0.675 0.725 0.75] * (max(max(SPHETModel.ChgCurrLim_cont_A)) * SPHETModel.V_cell_nom * SPHETModel.Ns * SPHETModel.Nmod);
SPHETModel.mtr_regen_pwr_spdbpt = [0 2 4 8 12 16 20 25 30 35];

%% Generator Motor Parameters - EMRAX 268
SPHETModel.n_gen_motors = 1;
load('YASA400_data.mat')
SPHETModel.peak_gen_mtr_trq_map = YASA400_pktrq_Nm;
SPHETModel.peak_gen_mtr_trq_spdbpt = YASA400_spdbpt_rpm;
SPHETModel.peak_gen_mtr_pwr_map = YASA400_pkpwr_kW;
SPHETModel.cont_gen_mtr_trq_map = YASA400_conttrq_Nm;
SPHETModel.cont_gen_mtr_trq_spdbpt = YASA400_spdbpt_rpm;
SPHETModel.cont_gen_mtr_pwr_map = YASA400_contpwr_kW;
SPHETModel.gen_mtr_eff_map = YASA400_effMap;
SPHETModel.gen_mtr_trqbpt = YASA400_trqbpt_Nm;
SPHETModel.gen_mtr_spdbpt = YASA400_spdbpt_rpm;

%% Transmission Parameters
SPHETModel.plnt_gear_eff = 0.98;
SPHETModel.gear_ratio = 5.2;
SPHETModel.mg_Ns = 34;                % Number of teeth on the sun gear
SPHETModel.mg_Nr = 80;                % Number of teeth on the ring gear
SPHETModel.mg_Npm = 50;               % Number of teeth on the motor pinion
SPHETModel.mg_ratio_eng_gen = SPHETModel.mg_Ns/(SPHETModel.mg_Ns + SPHETModel.mg_Nr);
SPHETModel.mg_ratio_eng_out = SPHETModel.mg_Nr/(SPHETModel.mg_Ns + SPHETModel.mg_Nr);
SPHETModel.mg_ratio_out_gen = SPHETModel.mg_Ns/SPHETModel.mg_Nr;
SPHETModel.mg_ratio_mot_out = SPHETModel.mg_Nr/SPHETModel.mg_Npm;
SPHETModel.mg_ratio_eng_mot = SPHETModel.mg_ratio_eng_out * SPHETModel.mg_ratio_mot_out;



%% Miscellaneous
SPHETModel.axle_inertia_kgm2 = 360;