% Parent script to call the SHEV DP optimization function.

%-- Load drive cycle 
drvCycle.time_s = [];           % Time Vector - 1 Hz(required)
drvCycle.spd_mph = [];          % Speed Vector
drvCycle.grade_pct = [];        % Road Grade Vector
numCycle = 1;      
SIM_RANGE_VEC = [50 75 100 125 150];
choice = 2;                     % Choice 1: To load from txt file
                                % Choice 2: To load from Google Drive
                                % Traces
subchoice = 1;                  % Choice 1: Normal trace
                                % Choice 2: Random trace
reOptchoice = 0;                % Choice 0: Not ReOptimizing
                                % Choice 1: ReOptimizing
motDerFaultSet = 0;             % Choice 0: No Motor Deration Fault
                                % Choice 1: Motor Deration Fault Active
drvCycle.tripTypeChoice = 'custom';     % one-way: Makes minFsblRng = 0;
                                        % return: Makes minFsblRng = Distance of
                                        % travel in one direction.
                                        % custom: User supplies own min feasible 
                                        % range.
%% Calculate the speed limit due to motor deration fault
P_der = 30000;
T_cont = 180;

for jj = 1:length(numCycle)
    if ~isempty(drvCycle)
        switch choice
            case 1
                test = table2array(readtable('custcycle.txt','HeaderLines', 2));
                for i = 1:numCycle(jj)
                    if i == 1
                        drvCycle.time_s = test(:,1); %[test(:,1);(test(:,1) + test(end,1) + 1)];
                        drvCycle.spd_mph = test(:,2); %[test(:,2);test(:,2)];
                    else
                        drvCycle.time_s = [drvCycle.time_s;
                                           drvCycle.time_s(end) + test(:,1) + 1];
                        drvCycle.spd_mph = [drvCycle.spd_mph;
                                   test(:,2)]; %[test(:,2);test(:,2)];
                    end
                end
            case 2
                fileName = 'Apr292020_Portland_HoodRiver.mat'; %Dec062019154949 Dec032019165351
%                 if ispc
%                     pathName = 'C:\Users\Aman-Home\Documents\MATLAB\DocResWork\Simulation_Models\PreDrive_DP_Optimization\RouteSelectorApp\Google_Drive_Traces\';
%                 elseif ismac
%                     pathName = '/Users/amankalia/Documents/MATLAB/DocResWork/Simulation_Models/PreDrive_DP_Optimization/RouteSelectorApp/Google_Drive_Traces/';
%                 end
%                 load(strcat(pathName,fileName));
                load(strcat(fileName));
                eval(['tempLoad =',fileName(1:end-4),';'])
                switch subchoice
                    case 1
                        for i = 1:numCycle(jj)
                            if i == 1
                                drvCycle.time_s = tempLoad.time_s; 
                                drvCycle.spd_mph = tempLoad.spd_mph; 
                                drvCycle.grade_pct = tempLoad.grade_pct * 0;
                            else
                                drvCycle.time_s = [drvCycle.time_s;
                                                   drvCycle.time_s(end) + tempLoad.time_s + 1];
                                drvCycle.spd_mph = [drvCycle.spd_mph;
                                           tempLoad.spd_mph]; %[test(:,2);test(:,2)];
                                drvCycle.grade_pct = [drvCycle.grade_pct; 
                                                      tempLoad.grade_pct];
                            end
                        end
                    case 2
                        for i = 1:numCycle
                            if i == 1
                                drvCycle.time_s = tempLoad.time_s; 
                                drvCycle.spd_mph = tempLoad.rand_spd_mph; 
                                drvCycle.grade_pct = tempLoad.grade_pct;
                            else
                                drvCycle.time_s = [drvCycle.time_s;
                                                   drvCycle.time_s(end) + tempLoad.time_s + 1];
                                drvCycle.spd_mph = [drvCycle.spd_mph;
                                           tempLoad.rand_spd_mph]; %[test(:,2);test(:,2)];
                                drvCycle.grade_pct = [drvCycle.grade_pct; 
                                                      tempLoad.grade_pct];
                            end
                        end
                end                   
        end           
    end
    clear test i                        % Remove unwanted variables

    %% SPHET Parameters
    vehParams.SOC_Max = 0.9;
    vehParams.SOC_Begin = 0.8;              % Upper Limit on SOC
    vehParams.SOC_Final = 0.5;              % Lower Limit to be maintained for SPHET
    vehParams.Fuel_init = SPHETModel.fuelTankCap_L; % Liters. 1 Gallons = 3.785L
    vehParams.VehMass = SPHETModel.veh_mass_kg;     % kg
    vehParams.rl_a = 319.91;                % lbs
    vehParams.rl_b = 3.199;                 % lbs/(mph)
    vehParams.rl_c = 0.149;                 % lbs/(mph)^2
    vehParams.L_aux = (SPHETModel.P_aux_elec + SPHETModel.P_aux_mech)*0.5; % Auxiliary Load
    vehParams.SOC_PRCSN = 0.00002;
    vehParams.minFsblRng = 50000;           % Meters
    vehParams.P_gen_max = -63000;           % Can change based on fault insertion.
    vehParams.P_mot_max = 245500;           % Continuous Motor Power
    %% Re-optimization Parameters
    switch reOptchoice
        case 0
            drvCycle.startIdx = 1;
            vehParams.SOC_Min  = 0.2;
            vehParams.SOC_ReOpt = vehParams.SOC_Begin;
        case 1
            drvCycle.startIdx = simidx.Data(end);        
            vehParams.SOC_Min = 0.2; %N_OptResults.optSOC_pct(end);
            vehParams.SOC_ReOpt = simbattSOC.Data(end);
    end
    %% Call Optimization Function
    simChoice = 1;              % 1 : Single Simulation
                                % 2 : Sweep Range Simulation
                                % 3 : Sweep Init SOC Simulation
    switch simChoice
        case 1
            tic
            [OptResults] = opt_SPHET_DP(drvCycle,vehParams);
            t_sim = toc;
            OptResults.optTime_s = t_sim;
            switch reOptchoice
                case 0
                    continue
                case 1
                    old_N_OptResults = N_OptResults;
                    N_OptResults = OptResults;
                    set_param('het_platoon_model', 'SimulationCommand', 'update')
                    %pause(5)
                    %set_param('SHEV_Camaro_PwrLossMdl', 'SimulationCommand', 'continue')
            end
        case 2
            RANGEVEC = [0,25000,50000,75000,100000,150000,200000,250000];
            for i = 1:length(RANGEVEC)
                vehParams.minFsblRng = RANGEVEC(i);
                tic
                eval(['[OptResults_RangeSweep_',int2str(i),'] = optimize_SHEV_DP(drvCycle,vehParams);'])
                t_sim = toc;
                eval(['OptResults_RangeSweep_',int2str(i),'.optTime_s = t_sim;'])
            end
        case 3
            INITSOCVEC = 0.2:0.2:1.0;
            for i = 1:length(INITSOCVEC)
                vehParams.SOC_Begin = INITSOCVEC(i);
                vehParams.SOC_ReOpt = vehParams.SOC_Begin;
                tic
                eval(['[FT6000_FebTrace_',int2str(INITSOCVEC(i)*100),'] = optimize_SHEV_DP(drvCycle,vehParams);'])
                t_sim = toc;
                eval(['FT6000_FebTrace_',int2str(INITSOCVEC(i)*100),'.optTime_s = t_sim;'])
                fName = strcat('FT6000_FebTrace_',int2str(INITSOCVEC(i)*100));
                dir = 'C:\Users\Aman-Home\Documents\MATLAB\DocResWork\Simulation_Models\FaultTolerantDP\';
                save(strcat(dir,fName,'.mat'),fName)
            end
        case 4  % This case is for DP Heatmap sweep only
            INITSOCVEC = 0.2:0.1:1.0;
            for i = 1:length(INITSOCVEC)
                vehParams.SOC_Begin = INITSOCVEC(i);
                tic
                eval(['[US06_',int2str(SIM_RANGE_VEC(jj)),'mi_',int2str(INITSOCVEC(i)*100),'_Fwd_DP] = optimize_SHEV_DP(drvCycle,vehParams);'])
                t_sim = toc;
                eval(['US06_',int2str(SIM_RANGE_VEC(jj)),'mi_',int2str(INITSOCVEC(i)*100),'_Fwd_DP.optTime_s = t_sim;'])
                fName = strcat('US06_',int2str(SIM_RANGE_VEC(jj)),'mi_',int2str(INITSOCVEC(i)*100),'_Fwd_DP');
                dir = 'Simulation_Results/Forward_Prop_3/';
                save(strcat(dir,fName,'.mat'),fName)
            end
    end
end
%% Save function
