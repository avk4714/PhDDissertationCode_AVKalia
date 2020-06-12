% Associated parameter load script with lib_ESS (ESS Library models) for 
% A123 ESS Model.
%
% Note: Keep adding different model parameters for ESS models in lib_ESS to
% this script for run-time load in Workspace.
%
%% Parameters
% Battery Parameters
A123_ESS.Q_cell_max_Ah = 19.6;
A123_ESS.Ns = 15;
A123_ESS.Np = 3;
A123_ESS.Nmod = 7;
A123_ESS.Init_soc = 0.915;

% Estimated Parameters
% Load -mat file containing the estimated parameters

load('FinalFit_062519_ESS_2.mat')   % Can be changed if file changes

% Miscellaneous Settings
% time step setting can be added same as the simulation time step.
