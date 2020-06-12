% Use this script to plot and generate a function fit for the Cd benefit
% data from 2018 SAE Paper by Salari et al.

% The data structures are named as follows:
% Sal2018_2.woBT_LT --> 2 truck data without boat tail for lead truck
% Sal2018_3.wBT_LT  --> 3 truck data with boat tail for lead truck
%% Initialization
Cd_avg = 0.52;
%% Load Dataset
load('Salari_dataset.mat')
% Sal2018.TP_2.LT_Cf_Skirt = Sal2018.TP_2.LT_Cd_Skirt(2:20) - Sal2018.TP_2.LT_Cp_Skirt;
% Sal2018.TP_2.TT_Cf_Skirt = Sal2018.TP_2.TT_Cd_Skirt(2:20) - Sal2018.TP_2.TT_Cp_Skirt;
%% Dataset - 2 truck
% Lead Truck Cd, Cd Benefit and Cp
figure;
ax(1) = subplot(4,1,1);
scatter(Sal2018.TP_2.sepDistBpt,Sal2018.TP_2.LT_Cd_Skirt,'filled')
hold on
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.TP_2.LT_Cp_Skirt,'filled')
ylim([-0.1 1.1])
grid on
title('C_d Norm , C_p')
ax(2) = subplot(4,1,2);
scatter(Sal2018.TP_2.sepDistBpt,Sal2018.TP_2.LT_CdBen_Skirt,'filled')
ylim([-5 40])
grid on
title('C_d Benefit %')
ax(3) = subplot(4,1,3);
scatter(Sal2018.TP_2.sepDistBpt,Sal2018.TP_2.LT_Cd_Skirt * Cd_avg,'filled')
hold on
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.TP_2.LT_Cp_Skirt,'filled')
ylim([-0.1 1.1])
grid on
title('C_d, C_p')
ax(4) = subplot(4,1,4);
scatter(Sal2018.TP_2.Cp_sepDistbpt,(Sal2018.TP_2.LT_Cd_Skirt(2:20)*Cd_avg) - Sal2018.TP_2.LT_Cp_Skirt,'filled')
grid on
title('C_f')
linkaxes(ax,'x')

% Tail Truck Cd, Cd Benefit and Cp
figure;
ax1(1) = subplot(4,1,1);
scatter(Sal2018.TP_2.sepDistBpt,Sal2018.TP_2.TT_Cd_Skirt,'filled')
ylim([0 1.2])
grid on
title('C_d')
ax1(2) = subplot(4,1,2);
scatter(Sal2018.TP_2.sepDistBpt,Sal2018.TP_2.TT_CdBen_Skirt,'filled')
ylim([-5 40])
grid on
title('C_d Benefit %')
ax1(3) = subplot(4,1,3);
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.TP_2.TT_Cp_Skirt,'filled')
ylim([-0.1 1.1])
grid on
title('C_p')
ax1(4) = subplot(4,1,4);
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.TP_2.TT_Cf_Skirt,'filled')
ylim([-0.1 1.1])
grid on
title('C_f')
linkaxes(ax1,'x')

%% Dataset - 3 truck
figure;
ax2(1) = subplot(4,1,1);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.TP_3_30.LT_Cd_Skirt,'filled')
ylim([0 1.2])
grid on
title('C_d')
ax2(2) = subplot(4,1,2);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.TP_3_30.LT_CdBen_Skirt,'filled')
ylim([-5 40])
grid on
title('C_d Benefit %')
ax2(3) = subplot(4,1,3);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.TP_3_30.LT_Cp_Skirt,'filled')
ylim([-0.1 1.1])
grid on
title('C_p')
ax2(4) = subplot(4,1,4);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.TP_3_30.LT_Cf_Skirt,'filled')
ylim([-0.1 1.1])
grid on
title('C_f')
linkaxes(ax,'x')
