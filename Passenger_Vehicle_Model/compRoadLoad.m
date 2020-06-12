    %% Input Speed - mps
    v_spd = [0:1:60] * 0.44704;
    v_spd_mph = [0:1:60];
    %%
    alpha = 0;
    
    %% Static Parameters
    % -- Vehicle
    A_veh = 0.4;        % [m^2]
    C_d = 0.34;         % drag coefficient [-]
    m_veh = 1875;       % [kg]
    P_tire = 32;        % [psi]
    R_tire = 0.346;     % [m]
    N_drvnWhl = 2;      % [-]
    Rat_gbx = 4.2;
    
    rl_a = 20.77;
    rl_b = 0.005;
    rl_c = 0.0037;
    
    % -- Environment
    g = 9.81;           % acceleration due to gravity [m/s^2]
    rho_air = 1.225;    % STP density [kg/m^3]
    
    %% Dynamic Parameters
    C_rr = 0.005 + ((0.06895/P_tire) * ...
        (0.01 + (0.0095 * ((2.778 * (10^-3) * v_spd).^2))));   
    
    %% Load Equation - 1

    Pwr_Load_1 = ((0.5 * rho_air * A_veh * C_d * (v_spd .^ 2)) + ...
            (m_veh * g * sin(alpha)) + ...
            (C_rr * m_veh * g));
        
    %% Load Equation - 2
    
    Pwr_Load_2 = (((rl_c * (v_spd_mph.^2)) + ...
        (rl_b * (v_spd_mph)) + (rl_a)) * 4.448);
    
    %% Plot
    figure;
    plot(v_spd_mph,Pwr_Load_1)
    hold on
    plot(v_spd_mph,Pwr_Load_2)
    grid on
    makePublishable(0)