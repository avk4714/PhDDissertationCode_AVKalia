%% Script Description

%% Open Model

% ## Check if model is already loaded, if not then open system
try
    openStat = get_param('test_CT_model','Shown');
catch
    open_system('test_CT_model') 
end

%% Load Simulation Parameters

t_step = 0.1;      % Simulation time step [seconds]

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
    case 7 % WOT (0 - 60 mph)
        simDrv.spd_mps = [0 0 60 60]' * 0.447;
        simDrv.time_s = [0 5 10 100]';
        simDrv.grade_pct = [0 0 0 0]';
    case 8 % Steady Speed (60 mph)
        simDrv.time_s = 0:1:100;
        simDrv.spd_mps = ones(size(simDrv.time_s)) * 60 * 0.447;
        simDrv.grade_pct = 2 * sin(2*pi*(simDrv.time_s/25));
        simDrv.time_s = simDrv.time_s';
        simDrv.spd_mps = simDrv.spd_mps';
        simDrv.grade_pct = simDrv.grade_pct';
    otherwise
        error('Incorrect selection value.')
end

%% Load Simulation Parameters
CT_accPdl_trqMap = [0,0.075,0.15,0.25,0.35,0.45,0.55,0.625,0.7,0.8,0.9,1.0,1.0,1.0;
                    0,0.06,0.12,0.20,0.30,0.40,0.50,0.60,0.7,0.8,0.9,1.0,1.0,1.0;
                    0,0.04,0.08,0.16,0.26,0.36,0.46,0.56,0.62,0.7,0.8,0.9,1.0,1.0;
                    0,0.03,0.06,0.12,0.22,0.32,0.42,0.52,0.62,0.68,0.78,0.88,0.98,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0;
                    0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
CT_accPdl_pdlbpt = [0,0.02,0.05,0.08,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
CT_accPdl_spdbpt = [0,5,10,15,20,25,30,35];
CT_brkPdl_brkTrq = [0,100,200,300,400,500,500];
CT_brkPdl_pdlbpt = [0,0.05,0.1,0.25,0.5,0.75,1.0];

%% Powertrain Data
run('paramsCTModel.m')
