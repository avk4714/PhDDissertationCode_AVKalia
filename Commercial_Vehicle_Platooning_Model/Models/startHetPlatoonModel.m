%% Script Description

%% Open Model

% ## Check if model is already loaded, if not then open system
try
    openStat = get_param('het_platoon_model','Shown');
catch
    open_system('het_platoon_model') 
end

%% Load Simulation Parameters

sim_t_step = 0.01;      % Simulation time step [seconds]

% Load drive cycle
opt = 7;
switch opt
    case 1  %EPA UDDS HD Cycle
        gfile = 'EPA_UDDS_HD';  
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 2  %NREL Port Dryage Composite Cycle California
        gfile = 'NREL_PD_CC_CA';
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 3  %NREL Port Dryage Creep Queue Cycle California
        gfile = 'NREL_PD_CQC_CA';  
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 4  %NREL Port Dryage Local Cycle California
        gfile = 'NREL_PD_LC_CA';  
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 5  %NREL Port Dryage Metro Highway Cycle California
        gfile = 'NREL_PD_MHC_CA';
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 6  %NREL Port Dryage Near Dock Cycle California
        gfile = 'NREL_PD_NDC_CA';
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 7 % WOT (0 - 70 - 60 - 0 mph)
        simDrv.spd_mps = [0 0 70 70 60 60 0 0]' * 0.447;
        simDrv.time_s = [0 5 5.1 200 220 320 320.1 420]';
        simDrv.grade_pct = [0 0 0 0 0 0 0 0]';
        del_t = simDrv.time_s(2:end) - simDrv.time_s(1:end-1);
        del_dist = simDrv.spd_mps(2:end) .* del_t;
        simDrv.dist_m = cumsum([0;del_dist]);
        clear del_t del_dist
    case 8 % Steady Speed (60 mph)
        simDrv.time_s = 0:1:100;
        simDrv.spd_mps = ones(size(simDrv.time_s)) * 60 * 0.447;
        simDrv.grade_pct = 2 * sin(2*pi*(simDrv.time_s/25));
        simDrv.time_s = simDrv.time_s';
        simDrv.spd_mps = simDrv.spd_mps';
        simDrv.grade_pct = simDrv.grade_pct';
        simDrv.dist_m = cumsum(simDrv.spd_mps);
    case 9 % 55-60-65-60-55
        simDrv.time_s = [0 5 15 315 330 630 645 945 960 1260 1275 1575]';
        simDrv.spd_mps = [0 0 55 55 60 60 65 65 60 60 55 55]' * 0.447;
        simDrv.grade_pct = [0 0 0 0 -1 0 -1 0 1 0 1 0]' * 5;
        del_t = simDrv.time_s(2:end) - simDrv.time_s(1:end-1);
        del_dist = simDrv.spd_mps(2:end) .* del_t;
        simDrv.dist_m = cumsum([0;del_dist]);
        clear del_t del_dist
    case 10 % Highway Step
        gfile = 'HwyStep';
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    case 11 % Custom Cycles
        gfile = 'Apr292020_Portland_HoodRiver'; % Apr292020_Snoq_Yakima Apr292020_Portland_HoodRiver Apr292020_Colfax_Reno
        load(strcat(gfile,'.mat'))
        eval(['simDrv = ',gfile,';'])
    otherwise
        error('Incorrect selection value.')
end

%% Load Simulation Parameters
% 1. Common Parameters
AccPdl_trqMap = [0,0.075,0.15,0.25,0.35,0.45,0.55,0.625,0.7,0.8,0.9,1.0,1.0,1.0;
                    0,0.06,0.12,0.20,0.30,0.40,0.50,0.60,0.7,0.8,0.9,1.0,1.0,1.0;
                    0,0.04,0.08,0.16,0.26,0.36,0.46,0.56,0.62,0.7,0.8,0.9,1.0,1.0;
                    0,0.03,0.06,0.12,0.22,0.32,0.42,0.52,0.62,0.68,0.78,0.88,0.98,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
AccPdl_pdlbpt = [0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
AccPdl_spdbpt = [0,5,10,15,20,25,30,35];
BrkPdl_brkTrq = [0,100,200,300,400,500,500];
BrkPdl_pdlbpt = [0,0.05,0.1,0.25,0.5,0.75,1.0];
init_veh_spd_mps = 0;

%% Powertrain Data
run('paramsCTModel.m')
run('paramsSPHETModel.m')
run('paramsBETModel.m')
%% Load Cd Maps
load('Platoon_Cd_Map_Updated.mat')
load('Platoon_Cd_Map_T2.mat')
min_Cd_frac = 0.72; % 28% benefit max
max_Cd_frac = 1;    % No Benefit

%% Platoon Configuration Parameters & Batch Simulation
% The truck type can be selected for the variant subsystem at Lead, Mid and
% Tail positions.
% 1: Conventional
% 2: Series Parallel Hybrid Electric
% 3: Battery Electric

LT.Init_Pos_m = 0;
MT.Init_Pos_m = 0;
TT.Init_Pos_m = 0;

LT.Length_m = 14.63;
MT.Length_m = 14.63;
TT.Length_m = 14.63;

% %% Simulation Settings
% MDL_NAME = 'het_platoon_model';
% 
LT.Type = 1;
MT.Type = 2;
TT.Type = 3;
% set_param(MDL_NAME, 'SimulationCommand', 'update')
%%
% sim(MDL_NAME)

% BATCH_FLAG = 0;
% BATCH_FLAG
% 0: No Batch Run
% 1: Batch Run (requires a batch run variable in Workspace





