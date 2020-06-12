% Use this script to save workspace variables as a MAT file

fileName = 'EEC_150mi_20_Fwd_DP.mat';
dir = 'Simulation_Results/Forward_Prop/';

save(strcat(dir,fileName),'DistTrvld_m','drvCycle','EC_Wh_m','estRange_m',...
    'fsblRange','L_total','P_batt_opt','P_gen_opt','P_regen_opt','X_lim',...
    'X_opt','NetEC_opt','P_fuel_opt')

clear all