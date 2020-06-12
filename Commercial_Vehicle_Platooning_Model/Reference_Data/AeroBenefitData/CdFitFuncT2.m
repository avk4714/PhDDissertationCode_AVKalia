function [map] = CdFitFuncT2(d_1)
%CDFITFUNCT2 Generates Cd variation for two truck platoon
%   Uses a power fit function of the type: -a * (x^-b) +c
%% LT Coeff
LT_A = 0.2628;
LT_B = 0.7126;
LT_C = 0.5363;
%% TT Coeff
TT_A = 3.852;
TT_B = 0.00435;
TT_C = 4.245;
%% Solution
Cd_LT_est = zeros([length(d_1) 1]);
Cd_TT_est = zeros([length(d_1) 1]);
temp = zeros([length(d_1) 2]);
for i = 1:length(d_1)
   Cd_LT_est(i) = -LT_A * (d_1(i)^(-LT_B)) + LT_C;
   Cd_TT_est(i) = -TT_A * (d_1(i)^(-TT_B)) + TT_C;
end
temp(:,1) = Cd_LT_est;
temp(:,2) = Cd_TT_est;
map = temp;
end

