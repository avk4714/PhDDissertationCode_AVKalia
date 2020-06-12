function [map] = CdFitFunc(d_1,d_2)
%CDFITFUNC Summary of this function goes here
%   Detailed explanation goes here
%% LT Cd Coeff
LT_A = 1.509;
LT_B = 1.997; 
LT_C = 0.6847;
LT_D = 0.5185;
LT_E = 2.005;
LT_F = 0.000473;
LT_G = 3.047;
LT_H = 1.982;
LT_K = -0.1609;
%% MT Cd Coeff
MT_A = -1.274;
MT_B = 0.9736;
MT_C = -0.3474;
MT_D = -1.306;
MT_E = 0.9685;
MT_F = 0.08375;
MT_G = 1.546; 
MT_H = 0.06854;
MT_K = 1.849;
%% TT Cd Coeff
TT_A = 0.2936;
TT_B = 0.4855;
TT_C = 1.251;
TT_D = 0.7645;
TT_E = 0.003518;
TT_F = 0.7398;
TT_G = -0.2756; 
TT_H = 1.133;
TT_K = -0.8248;
%% Cd Generating Function
Cd_LT_est = zeros([length(d_1) length(d_2)]);
Cd_MT_est = zeros([length(d_1) length(d_2)]);
Cd_TT_est = zeros([length(d_1) length(d_2)]);
temp = zeros([length(d_1) length(d_2) 3]);
for i = 1:length(d_1)
    for j = 1:length(d_2)
        Cd_LT_est(i,j) = (-LT_A * (d_1(i) ^ -LT_B) + LT_C) * ...
            (d_2(j) ^ -(-LT_D * (d_1(i) ^ -LT_E) + LT_F)) + (-LT_G * (d_1(i) ^ -LT_H) + LT_K);
        Cd_MT_est(i,j) = (-MT_A * (d_1(i) ^ -MT_B) + MT_C) * ...
            (d_2(j) ^ -(-MT_D * (d_1(i) ^ -MT_E) + MT_F)) + (-MT_G * (d_1(i) ^ -MT_H) + MT_K);
        Cd_TT_est(i,j) = (-TT_A * (d_1(i) ^ -TT_B) + TT_C) * ...
            (d_2(j) ^ -(-TT_D * (d_1(i) ^ -TT_E) + TT_F)) + (-TT_G * (d_1(i) ^ -TT_H) + TT_K);
    end
end
temp(:,:,1) = Cd_LT_est;
temp(:,:,2) = Cd_MT_est;
temp(:,:,3) = Cd_TT_est;
map = temp;
end

