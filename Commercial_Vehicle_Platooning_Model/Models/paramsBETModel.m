% INTRODUCTION:
% Load this script to get the Conventional Truck Model parameters loaded
% in the workspace. This script generates a structure variable which than
% has values that are used in the Conventional Truck Model. 
% P.S.: Modifications to the data can be made directly in this model for
% future use.
% MADE BY:
% Aman Ved Kalia
%% Vehicle Parameters
BETModel.veh_mass_kg = 35380;            % Gross Weight [kg] = 78000 lbs
BETModel.ld_tire_rad_m = 0.489;          % Loaded Tire Radius [kg]
BETModel.Af_m2 = 10.4;                   % Frontal Area [m^2]
BETModel.Cd_avg = 0.52;                  % Average Coefficient of Drag
BETModel.P_aux_elec = 1200;               % Auxiliary electric power [W]
BETModel.P_aux_mech = 1000;              % Auxilliary mechanical power [W]
BETModel.P_aux_load_frac = 0.5;          % Auxiliary Load fraction

%% HV Battery Parameters - A123 Battery Cells
load('A123Battery_450_data.mat')
load('ESS_DblPolDat.mat')
BETModel.V_cell_nom = 3.2;
BETModel.Q_cell_max_Ah = A123_HD_ESS.Q_cell_max_Ah;                
BETModel.Np = A123_HD_ESS.Np;                   
BETModel.Ns = A123_HD_ESS.Ns;                            
BETModel.Nmod = A123_HD_ESS.Nmod;
BETModel.socbpt = A123_HD_ESS.socbpt;
BETModel.cellTempbpt_C = A123_HD_ESS.cellTempbpt_C;
BETModel.DchgCurrLim_10sAvg_A = A123_HD_ESS.DchgCurrLim_10sAvg_A;
BETModel.ChgCurrLim_10sAvg_A = A123_HD_ESS.ChgCurrLim_10sAvg_A;
BETModel.DchgCurrLim_cont_A = A123_HD_ESS.DchgCurrLim_cont_A;
BETModel.ChgCurrLim_cont_A = A123_HD_ESS.ChgCurrLim_cont_A;
BETModel.batt_R0 = R0;
BETModel.batt_R1 = R1;
BETModel.batt_R2 = R2;
BETModel.batt_C1 = C1;
BETModel.batt_C2 = C2;
BETModel.batt_socbpt = soc_bpt;

%% Traction Motor Parameters
BETModel.mtr_eff = 0.95;
BETModel.n_motors = 4;
load('Dana_HD3500_data.mat')
BETModel.peak_mtr_trq_map = HD3500_pktrq_Nm;
BETModel.peak_mtr_trq_spdbpt = HD3500_spdbpt_rpm;
BETModel.peak_mtr_pwr_map = HD3500_pkpwr_kW;
BETModel.cont_mtr_trq_map = HD3500_conttrq_Nm;
BETModel.cont_mtr_trq_spdbpt = HD3500_spdbpt_rpm;
BETModel.cont_mtr_pwr_map = HD3500_contpwr_kW;
BETModel.mtr_regen_pwr_vec = -1 * [0 0.025 0.075 0.15 0.3 0.45 0.6 0.675 0.725 0.75] * (max(max(BETModel.ChgCurrLim_cont_A)) * BETModel.V_cell_nom * BETModel.Ns * BETModel.Nmod);
BETModel.mtr_regen_pwr_spdbpt = [0 2 4 8 12 16 20 25 30 35];

%% Transmission Parameters
BETModel.gear_eff = 0.98;
BETModel.gear_ratio = 5.2;

%% Miscellaneous
BETModel.axle_inertia_kgm2 = 360;