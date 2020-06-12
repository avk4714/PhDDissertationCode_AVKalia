function [optResults] = optimize_SHEV_DP(driveParams,vehParams)
%OPTIMIZE_SHEV_DP Generates optimal operating points for SHEV using DP.
%   The function is based on the SHEV_DP_FwdProp.m script to assist in an
%   easier integration with Simulink for RT evaluation. The input argument
%   is form of structure.

%   -> driveParams : Includes drive trace parameters
%   -->driveParams.time_s
%   -->driveParams.spd_mph
%   -->driveParams.grade_pct
%   -->driveParams.startIdx
%   -->driveParams.tripTypeChoice

%   -> vehParams : Includes vehicle initialization parameters
%   -->vehParams.SOC_Max
%   -->vehParams.SOC_Min
%   -->vehParams.SOC_Begin
%   -->vehParams.SOC_Final
%   -->vehParams.Fuel_init
%   -->vehParams.VehMass
%   -->vehParams.rl_a
%   -->vehParams.rl_b
%   -->vehParams.rl_c
%   -->vehParams.L_aux  
%   -->vehParams.SOC_PRCSN
%   -->vehParams.minFsblRng
%   -->vehParams.SOC_ReOpt
%   -->vehParams.P_gen_max

%   # Output structure is as follows:
%   -> optResults : Includes optimization results for the model
%   -->optResults.optSOC_pct
%   -->optResults.optPgen_W
%   -->optResults.optPbatt_W
%   -->optResults.optPfuel_W
%   -->optResults.optPregen_W
%   -->optResults.optNetEC
%   -->optResults.fsblRange_m
%   -->optResults.estRange_m
%   -->optResults.EC_Wh_m
%   -->optResults.minFsblRng_m
%   -->optResults.Veh_Load_W
%   -->optResults.Veh_Dem_W

%% Main Body
%-- SHEV State Vector
SOC_Max = vehParams.SOC_Max;
SOC_Min = vehParams.SOC_Min;
SOC_Begin = vehParams.SOC_Begin;
SOC_ReOpt = vehParams.SOC_ReOpt;
SOC_Final = vehParams.SOC_Final;
SOC_Range = [];                     % Initializing SOC_range vector as an
                                    % empty vector
MAX_FUEL = vehParams.Fuel_init;     % Liters. 1 Liter = 0.264172. 
                                    % Max is 26.49
LHV_FUEL = 30000;                   % kJ/kg or J/g
RHO_FUEL = 783;                     % g/L
J2WH_CONV = 0.00027778;             % Conversion multiplier
N = length(driveParams.time_s);
STRTIDX = driveParams.startIdx;     % To assist with re-optimization

%-- Vehicle Parameters
VehMass = vehParams.VehMass;        % Vehicle + Driver
rl_a = vehParams.rl_a;
rl_b = vehParams.rl_b;
rl_c = vehParams.rl_c;
L_aux = vehParams.L_aux;            % Auxiliary load due to electronics [W]

E_batt = 18900;                         % Wh
P_gen_max = vehParams.P_gen_max;        %-15000; %-11500;    % W
P_batt_dchg_max = 208000;               % W
P_batt_ch_max = -102000;                % W
P_regen_max = -15000;                   % W

for ii = 1:N
    if ii == 1
        L_drv(ii,1) = 0;
        acc_drv(ii,1) = 0;
    else                                % Power = mass * acc * velocity [W]
        acc_drv(ii,1) = (((driveParams.spd_mph(ii) -...
            driveParams.spd_mph(ii-1))*0.447)/(driveParams.time_s(ii)...
            - driveParams.time_s(ii-1)));
        L_drv(ii,1) = VehMass * acc_drv(ii,1) *...
            abs((driveParams.spd_mph(ii))*0.447);%driveParams.spd_mph(ii-1)
    end
    L_load(ii,1) = ((((rl_c * (driveParams.spd_mph(ii))^2)) +...
        (rl_b * driveParams.spd_mph(ii)) + (rl_a)) * 4.448) *...
        (driveParams.spd_mph(ii) * 0.447);
    L_total(ii,1) = calcMotElecPwr((L_drv(ii) +...
        L_load(ii)),driveParams.spd_mph(ii));
    if L_total(ii,1) <= 0
        L_total(ii,1) = max(P_batt_ch_max,L_total(ii,1));
    else
        L_total(ii,1) = min(P_batt_dchg_max,L_total(ii,1));
    end      
end

optResults.Veh_Dem_W = L_drv + L_load;
    
%-- Adaptive DP
% 1. Adjust power demand - Negative power demand values imply
% braking/stoppage. For ease of calculation, any power value below or equal
% to zero will be treated as a zero.

L_total = L_total + L_aux;


% 2. Total Energy Demand Associated with Drive Cycle and Distance
% Accmulated
for j = 1:N
    if j == 1
        E_dem_total(j,1) = 0;
        DistTrvld_m(j,1) = 0;
    else
        E_dem_total(j,1) = E_dem_total(j-1,1) + (L_total(j,1)/3600);   % Wh
        DistTrvld_m(j,1) = DistTrvld_m(j-1,1) + ...
            abs((driveParams.spd_mph(j-1)) * 0.44704);             % meters
    end
end

% 3. Delta Power - Calculate change in power demand between steps to
% determine discharge and charge scenarios. This helps compute feasible SOC
% limits.

delPwr_W = zeros(size(L_total));        % First element is zero by default.
for i = 2:N
    delPwr_W(i,1) = L_total(i,1) - L_total(i-1,1);
end

% 4. Initialize minimum and maximum SOC values - For each time instance, a
% min and max SOC value can be obtained based on drive cycle data as well
% as power and energy limits.

X_lim = zeros([N 2]);         % X represents state (SOC) here. First column
                              % is min value and second is max value.
                            
X_lim(STRTIDX,1) = SOC_Begin;% Initializing limits at initial time equal to 
X_lim(STRTIDX,2) = SOC_Begin;% the final SOC value.

X_PRCSN = vehParams.SOC_PRCSN;
% Precision for the SOC. 0.0001 corresponds to 0.01% SOC change.

% 5. Initialize additional variables and parameters

L_xN = 0;
X_opt = zeros([N 1]);                           % State (SOC)
P_gen_opt = zeros([N 1]);
P_batt_opt = zeros([N 1]);
P_battopt_total = zeros([N 1]);
P_regen_opt = zeros([N 1]);
P_fuel_opt = zeros([N 1]);
P_fuelopt_total = zeros([N 1]);
FuelUsed_L = zeros([N 1]);
fuelRate_opt = zeros([N 1]);

P_regen_LUT = [0 0;
               2.6 0;
               5.2 -1250;
               7.8 -3000;
               10.4 -5500;
               13 -8000;
               15.6 -10250;
               18.2 -12500;
               20.8 -13750;
               23.4 -14000;
               26 -14500;
               28.6 -15000;
               31.2 -15000;
               33.8 -15000;
               38 -15000];          % Regen power Lookup Table    
eta_genmot = 0.86;             % mean value obtained based on the Bosch ICD
%% Loop section - DP Forward Propagation
X_opt(1,1) = SOC_Begin;
X_opt(STRTIDX,1) = SOC_ReOpt;
l = STRTIDX + 1;
switch driveParams.tripTypeChoice
    case 'one-way'
        minFsblRng = 0;
    case 'return'
        minFsblRng = DistTrvld_m(end);          % meters
    case 'custom'
        minFsblRng = vehParams.minFsblRng;      % meters
    otherwise
        minFsblRng = 0;
end
FUEL_FLAG = 0;
while(l <= N)
    % disp(l)
    P_regen_avail = interp1(P_regen_LUT(:,1),P_regen_LUT(:,2),...
        (driveParams.spd_mph(l,1)*0.447),'linear');
    if L_total(l) > 0                               % Discharging condition
        % Step 1: Determine SOC Limits
        X_lim(l,2) = X_opt(l-1,1) -...
            ((L_total(l) + P_gen_max)/(E_batt * 3600));  % Max feasible SOC
        X_lim(l,1) = X_opt(l-1,1) -...
            ((L_total(l))/(E_batt * 3600));              % Min feasible SOC

        % NOTE: Here Max feasible SOC corresponds to with generator and Min 
        % is without generator. Because of Forward Propagation.

        % Step 2a: Form SOC Query Range and form delta SOC vector  
        X_range(:,1) = X_lim(l,1):X_PRCSN:X_lim(l,2);
        P_gen_range(:,1) = ((X_opt(l-1,1) - X_range) *...
            (E_batt * 3600)) - L_total(l);
        P_batt_range(:,1) = L_total(l) + P_gen_range(:,1);
        len_x_rng = length(X_range);
        fuelRate = zeros([len_x_rng 1]);

        for k = 1:len_x_rng
            if P_gen_range(k) < -500
                [engEff,fuelRate(k,1)] = calcEngEff(abs(P_gen_range(k)...
                    /eta_genmot));
                P_fuel_range(k,1) = (P_gen_range(k)/eta_genmot)*(1/engEff);
            else
                fuelRate(k,1) = 0;
                P_fuel_range(k,1) = 0;
            end
        end

        % Step 2b: Determine feasible SOC values based on range estimation
        ECvector_Wh_m(:,1) = ((X_opt(1,1) - X_range(:,1)) * E_batt)/...
           (DistTrvld_m(l,1) - DistTrvld_m(1,1));

        % Step 3a: Compute control candidate values corresponding to all
        % delta SOC
        for k = 1:len_x_rng
            if ECvector_Wh_m(k,1) > 0
                estRngVec_m(k,1) = ((X_range(k,1) - SOC_Min) * E_batt)...
                    /ECvector_Wh_m(k,1);
                fsblRngVec(k,1) = estRngVec_m(k,1) - (DistTrvld_m(end,1)...
                    - DistTrvld_m(l,1));
            else 
                estRngVec_m(k,1) = Inf;
                fsblRngVec(k,1) = estRngVec_m(k,1) - (DistTrvld_m(end,1)...
                    - DistTrvld_m(l,1));
            end

            P_gen(k) = P_gen_max *...
                ((X_range(k) - X_range(1))/(X_range(end) - X_range(1)));
            if P_gen(k) ~= 0 && ~isnan(P_gen(k))
                [engEff,~] = calcEngEff(abs(P_gen(k)/eta_genmot));
                P_fuel(k) = (P_gen(k)/eta_genmot) * (1/engEff);
            else
                P_fuel(k) = 0;
            end
            if (fsblRngVec(k,1) >= minFsblRng) && FUEL_FLAG == 0
                P_batt(k) = L_total(l) + P_gen(k);
            else
                P_batt(k) = Inf;  % Maximum penalty added for infeasibility
            end
            P_regen(k) = 0;
        end

        % Step 3b: If all solution values result in infinity
        if isinf(P_batt)
            if FUEL_FLAG == 0
                P_batt(end) = L_total(l) + P_gen(end);
            else
                P_batt(1) = L_total(l);
            end
        end

        % Step 4: Calculate Cost-to-go for each possible path.
        Y_x = (P_batt + abs(P_fuel))/3600;

        % Step 5: Determine optimal path as per cost function.
        opt_idx = find(Y_x == min(Y_x));
        
        % 4200 W is minimum power engine map can resolve
        if P_gen_max <= -500  
            % Step 6: Assign optimal SOC value and repeat.
            P_gen_opt(l,1) = P_gen(opt_idx);
            P_fuel_opt(l,1) = abs(P_fuel(opt_idx));
            P_batt_opt(l,1) = P_batt(opt_idx);
            P_regen_opt(l,1) = P_regen(opt_idx);
            X_opt(l,1) = X_range(opt_idx);
            fuelRate_opt(l,1) = fuelRate(opt_idx);
        else
            % Step 6: Assign optimal SOC value and repeat.
            P_gen_opt(l,1) = P_gen_max;
            P_fuel_opt(l,1) = P_fuel;
            P_batt_opt(l,1) = P_batt_range;
            P_regen_opt(l,1) = P_regen;
            X_opt(l,1) = X_range;
            fuelRate_opt(l,1) = fuelRate;
        end
        
    elseif L_total(l) <= 0            % Regen-braking condition
        % Step 1: Determine SOC Limits
        if L_total(l) > P_regen_avail
            L_final = L_total(l);
            X_lim(l,2) = X_opt(l-1,1) -...
                ((L_final + P_gen_max)/(E_batt * 3600)); % Max feasible SOC
            X_lim(l,1) = X_opt(l-1,1) -...
                ((L_final)/(E_batt * 3600));             % Min feasible SOC  
        else
            L_final = P_regen_avail;
            X_lim(l,2) = X_opt(l-1,1) -...
                ((L_final + P_gen_max)/(E_batt * 3600)); % Max feasible SOC
            X_lim(l,1) = X_opt(l-1,1) -...
                ((L_final)/(E_batt * 3600));             % Min feasible SOC   
        end
        
        % Step 2a: Form SOC Query Range and form delta SOC vector
        X_range(:,1) = X_lim(l,1):X_PRCSN:X_lim(l,2);
        P_gen_range(:,1) = ((X_opt(l-1,1) - X_range) *...
            (E_batt * 3600)) - L_total(l);
        P_batt_range(:,1) = L_total(l) + P_gen_range(:,1);
        len_x_rng = length(X_range);
        fuelRate = zeros([len_x_rng 1]);

        
        for k = 1:len_x_rng
            if P_gen_range(k) < -500
                [engEff,fuelRate(k,1)] = calcEngEff(abs(P_gen_range(k)...
                    /eta_genmot));
                P_fuel_range(k,1) = (P_gen_range(k)/eta_genmot) *...
                    (1/engEff);
            else
                fuelRate(k,1) = 0;
                P_fuel_range(k,1) = 0;
            end
        end
        
        ECvector_Wh_m(:,1) = ((X_opt(1,1) - X_range(:,1)) * E_batt)/...
           (DistTrvld_m(l,1) - DistTrvld_m(1,1));
        
        % Step 3a: Compute control candidate values corresponding to all
        % delta SOC
        for k = 1:len_x_rng
            if ECvector_Wh_m(k,1) > 0
                estRngVec_m(k,1) = ((X_range(k,1) - SOC_Min) * E_batt)...
                    /ECvector_Wh_m(k,1);
                fsblRngVec(k,1) = estRngVec_m(k,1) - (DistTrvld_m(end,1)...
                    - DistTrvld_m(l,1));
            else 
                estRngVec_m(k,1) = Inf;
                fsblRngVec(k,1) = estRngVec_m(k,1) - (DistTrvld_m(end,1)...
                    - DistTrvld_m(l,1));
            end
            % ---
            P_gen(k) = P_gen_max *...
                ((X_range(k) - X_range(1))/(X_range(end) - X_range(1)));
            if P_gen(k) ~= 0 && ~isnan(P_gen(k))
                [engEff,~] = calcEngEff(abs(P_gen(k)/eta_genmot));
                P_fuel(k) = (P_gen(k)/eta_genmot) * (1/engEff);
            else
                P_fuel(k) = 0;
            end
            P_regen(k) = L_final;
            % ---
            if (fsblRngVec(k,1) >= minFsblRng) && FUEL_FLAG == 0
                P_batt(k) = P_regen(k) + P_gen(k);
            else
                P_batt(k) = Inf;  % Maximum penalty added for infeasibility
            end    
        end
        
        % Step 3b: If all solution values result in infinity
        if isinf(P_batt)
            if FUEL_FLAG == 0
                P_batt(end) = L_total(l) + P_gen(end);
            else
                P_batt(1) = L_total(l);
            end
        end
        
        % Step 4: Calculate Cost-to-go for each possible path.
        Y_x = (P_batt + abs(P_fuel))/3600;
        
        % Step 5: Determine optimal path as per cost function.
        opt_idx = find(Y_x == min(Y_x));
        
        % 4200 W is minimum power engine map can resolve
        if P_gen_max <= -500 
            % Step 6: Assign optimal SOC value and repeat.
            P_gen_opt(l,1) = P_gen(opt_idx);
            P_fuel_opt(l,1) = abs(P_fuel(opt_idx));
            P_batt_opt(l,1) = P_batt(opt_idx);
            P_regen_opt(l,1) = P_regen(opt_idx);
            X_opt(l,1) = X_range(opt_idx);
            fuelRate_opt(l,1) = fuelRate(opt_idx);
        else
            % Step 6: Assign optimal SOC value and repeat.
            P_gen_opt(l,1) = P_gen_max;
            P_fuel_opt(l,1) = P_fuel;
            P_batt_opt(l,1) = P_batt_range;
            P_regen_opt(l,1) = P_regen;
            X_opt(l,1) = X_range;
            fuelRate_opt(l,1) = fuelRate;
        end

    end
    % Optimal solution addition
    P_battopt_total(l,1) = P_battopt_total(l-1,1) + P_batt_opt(l,1);
    P_fuelopt_total(l,1) = P_fuelopt_total(l-1,1) + P_fuel_opt(l,1);
    FuelUsed_L(l,1) = FuelUsed_L(l-1,1) + fuelRate_opt(l,1);
    
    % Fuel completion check
    if (MAX_FUEL - FuelUsed_L(l,1)) >= 0
        FUEL_FLAG = 0;
    else
        FUEL_FLAG = 1;
    end
    
    EC_Wh_m(l,1) = ((X_opt(1,1) - X_opt(l,1)) * E_batt)/(DistTrvld_m(l,1));
    
    if EC_Wh_m(l,1) > 0
        estRange_m(l,1) = ((X_opt(l,1) - SOC_Min) * E_batt)/EC_Wh_m(l,1);
        fsblRange(l,1) = estRange_m(l,1) - (DistTrvld_m(end,1)...
            - DistTrvld_m(l,1));
    else
        estRange_m(l,1) = Inf;
        fsblRange(l,1) = estRange_m(l,1) - (DistTrvld_m(end,1)...
            - DistTrvld_m(l,1));
    end
    l = l + 1;
end

if any(X_opt < SOC_Min)
    disp('## Infeasible Solution due to SOC violation ##')
    OPT_KEYWORD = 'UNSUCCESSFUL';
    idx = find(X_opt < SOC_Min, 1);
    NetEC_opt = ((sum(P_batt_opt(1:idx-1)) + sum(P_fuel_opt(1:idx-1)))...
        /3600)/DistTrvld_m(idx-1);    % Wh/m
else
    disp('## Optimization was successful for SOC ##')
    OPT_KEYWORD = 'SUCCESSFUL';
    NetEC_opt = ((sum(P_batt_opt) + sum(P_fuel_opt))/3600)...
        /DistTrvld_m(end);    % Wh/m
end

% Range based Feasibility
if fsblRange(end) < minFsblRng
    disp('## Infeasible solution due to range violation ##')
    OPT_KEYWORD_2 = 'UNSUCCESSFUL';
else
    disp('## Optimization was successful for Range ##')
    OPT_KEYWORD_2 = 'SUCCESSFUL';
end

%% Output Data Structure
optResults.optSOC_pct = X_opt;
optResults.optPgen_W = P_gen_opt;
optResults.optPbatt_W = P_batt_opt;
optResults.optPfuel_W = P_fuel_opt;
optResults.optPregen_W = P_regen_opt;
optResults.optNetEC = NetEC_opt;
optResults.fsblRange_m = fsblRange;
optResults.estRange_m = estRange_m;
optResults.distTrvld_m = DistTrvld_m;
optResults.EC_Wh_m = EC_Wh_m;
optResults.Veh_Load_W = L_load;
optResults.FuelUsed_L = FuelUsed_L;
optResults.minFsblRng_m = minFsblRng;
optResults.STATUS_KEY = OPT_KEYWORD;
optResults.STATUS_KEY_2 = OPT_KEYWORD_2;
end

