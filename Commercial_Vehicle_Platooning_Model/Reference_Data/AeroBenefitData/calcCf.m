% Use this script to calculate the Friction Coefficient for the 2 truck and
% 3 truck platoon data from Salari.
% C_d = C_p + C_f
% C_d and C_p data is available. C_f needs to be computed.
%% Initialization
Cd_Avg = 0.52;  % Change if truck style changes
%% Calculate C_f - 2 Truck Platooning
Sal2018.Calc_TP_2.LT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_2.LT_CdBen_Skirt(2:20)));
Sal2018.Calc_TP_2.TT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_2.TT_CdBen_Skirt(2:20)));
Sal2018.Calc_TP_2.LT_CpPltn = Cd_Avg * Sal2018.TP_2.LT_Cp_Skirt;
Sal2018.Calc_TP_2.TT_CpPltn = Cd_Avg * Sal2018.TP_2.TT_Cp_Skirt;
Sal2018.Calc_TP_2.LT_CfPltn = Sal2018.Calc_TP_2.LT_CdPltn - Sal2018.Calc_TP_2.LT_CpPltn;
Sal2018.Calc_TP_2.TT_CfPltn = Sal2018.Calc_TP_2.TT_CdPltn - Sal2018.Calc_TP_2.TT_CpPltn;

%% Plots - 2 Truck Platooning
figure;
ax(1) = subplot(2,1,1);
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.Calc_TP_2.LT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.Calc_TP_2.LT_CpPltn,'filled')
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.Calc_TP_2.LT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Lead Truck')
ax(2) = subplot(2,1,2);
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.Calc_TP_2.TT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.Calc_TP_2.TT_CpPltn,'filled')
scatter(Sal2018.TP_2.Cp_sepDistbpt,Sal2018.Calc_TP_2.TT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Tail Truck')
linkaxes(ax,'x')

%% Calculate C_f - 3 Truck Platooning - 30 ft (9 m) sep distance
Sal2018.Calc_TP_3_30.LT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_30.LT_CdBen_Skirt));
Sal2018.Calc_TP_3_30.MT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_30.MT_CdBen_Skirt));
Sal2018.Calc_TP_3_30.TT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_30.TT_CdBen_Skirt));
Sal2018.Calc_TP_3_30.LT_CpPltn = Cd_Avg * Sal2018.TP_3_30.LT_Cp_Skirt;
Sal2018.Calc_TP_3_30.MT_CpPltn = Cd_Avg * Sal2018.TP_3_30.MT_Cp_Skirt;
Sal2018.Calc_TP_3_30.TT_CpPltn = Cd_Avg * Sal2018.TP_3_30.TT_Cp_Skirt;
Sal2018.Calc_TP_3_30.LT_CfPltn = Sal2018.Calc_TP_3_30.LT_CdPltn - Sal2018.Calc_TP_3_30.LT_CpPltn;
Sal2018.Calc_TP_3_30.MT_CfPltn = Sal2018.Calc_TP_3_30.MT_CdPltn - Sal2018.Calc_TP_3_30.MT_CpPltn;
Sal2018.Calc_TP_3_30.TT_CfPltn = Sal2018.Calc_TP_3_30.TT_CdPltn - Sal2018.Calc_TP_3_30.TT_CpPltn;

%% Calculate C_f - 3 Truck Platooning - 40 ft (12 m) sep distance
Sal2018.Calc_TP_3_40.LT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_40.LT_CdBen_Skirt));
Sal2018.Calc_TP_3_40.MT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_40.MT_CdBen_Skirt));
Sal2018.Calc_TP_3_40.TT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_40.TT_CdBen_Skirt));
Sal2018.Calc_TP_3_40.LT_CpPltn = Cd_Avg * Sal2018.TP_3_40.LT_Cp_Skirt;
Sal2018.Calc_TP_3_40.MT_CpPltn = Cd_Avg * Sal2018.TP_3_40.MT_Cp_Skirt;
Sal2018.Calc_TP_3_40.TT_CpPltn = Cd_Avg * Sal2018.TP_3_40.TT_Cp_Skirt;
Sal2018.Calc_TP_3_40.LT_CfPltn = Sal2018.Calc_TP_3_40.LT_CdPltn - Sal2018.Calc_TP_3_40.LT_CpPltn;
Sal2018.Calc_TP_3_40.MT_CfPltn = Sal2018.Calc_TP_3_40.MT_CdPltn - Sal2018.Calc_TP_3_40.MT_CpPltn;
Sal2018.Calc_TP_3_40.TT_CfPltn = Sal2018.Calc_TP_3_40.TT_CdPltn - Sal2018.Calc_TP_3_40.TT_CpPltn;

%% Calculate C_f - 3 Truck Platooning - 50 ft (15 m) sep distance
Sal2018.Calc_TP_3_50.LT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_50.LT_CdBen_Skirt));
Sal2018.Calc_TP_3_50.MT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_50.MT_CdBen_Skirt));
Sal2018.Calc_TP_3_50.TT_CdPltn = Cd_Avg * (1 - (0.01 * Sal2018.TP_3_50.TT_CdBen_Skirt));
Sal2018.Calc_TP_3_50.LT_CpPltn = Cd_Avg * Sal2018.TP_3_50.LT_Cp_Skirt;
Sal2018.Calc_TP_3_50.MT_CpPltn = Cd_Avg * Sal2018.TP_3_50.MT_Cp_Skirt;
Sal2018.Calc_TP_3_50.TT_CpPltn = Cd_Avg * Sal2018.TP_3_50.TT_Cp_Skirt;
Sal2018.Calc_TP_3_50.LT_CfPltn = Sal2018.Calc_TP_3_50.LT_CdPltn - Sal2018.Calc_TP_3_50.LT_CpPltn;
Sal2018.Calc_TP_3_50.MT_CfPltn = Sal2018.Calc_TP_3_50.MT_CdPltn - Sal2018.Calc_TP_3_50.MT_CpPltn;
Sal2018.Calc_TP_3_50.TT_CfPltn = Sal2018.Calc_TP_3_50.TT_CdPltn - Sal2018.Calc_TP_3_50.TT_CpPltn;

%% Plots - 3 Truck Platooning
figure;
ax1(1) = subplot(3,3,1);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.LT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.LT_CpPltn,'filled')
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.LT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Lead Truck | LT-MT 9m')
ax1(2) = subplot(3,3,2);
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.LT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.LT_CpPltn,'filled')
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.LT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Lead Truck | LT-MT 12m')
ax1(3) = subplot(3,3,3);
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.LT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.LT_CpPltn,'filled')
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.LT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Lead Truck | LT-MT 15m')

ax1(4) = subplot(3,3,4);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.MT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.MT_CpPltn,'filled')
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.MT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Middle Truck | LT-MT 9m')
ax1(5) = subplot(3,3,5);
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.MT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.MT_CpPltn,'filled')
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.MT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Middle Truck | LT-MT 12m')
ax1(6) = subplot(3,3,6);
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.MT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.MT_CpPltn,'filled')
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.MT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Middle Truck | LT-MT 15m')

ax1(7) = subplot(3,3,7);
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.TT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.TT_CpPltn,'filled')
scatter(Sal2018.TP_3_30.sepDistBpt_30,Sal2018.Calc_TP_3_30.TT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Tail Truck | LT-MT 9m')
ax1(8) = subplot(3,3,8);
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.TT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.TT_CpPltn,'filled')
scatter(Sal2018.TP_3_40.sepDistBpt_40,Sal2018.Calc_TP_3_40.TT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Tail Truck | LT-MT 12m')
ax1(9) = subplot(3,3,9);
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.TT_CdPltn,'filled')
hold on
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.TT_CpPltn,'filled')
scatter(Sal2018.TP_3_50.sepDistBpt_50,Sal2018.Calc_TP_3_50.TT_CfPltn,'filled')
hold off
grid on
ylim([-0.1 1.1])
xlabel('Inter-truck separation distance [m]')
legend('C_d','C_p','C_f')
title('Tail Truck | LT-MT 15m')

linkaxes(ax1,'x')
