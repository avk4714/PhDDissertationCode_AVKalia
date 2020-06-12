% This script plots engine information along with the 10 Spd transmission
% for output torque and output power. The final drive ratio is common and
% also included in the evaluation.
% 1. Engine Peak Torque Output at different gears
gvec = CTModel.gear_ratios;
fdrat = CTModel.fd_ratio;
n = length(gvec);

% figure;
% for i = 1:n
%     plot((CTModel.peak_eng_trq_spd_bpt/(gvec(i)*fdrat)),(CTModel.peak_eng_trq_map*gvec(i)*fdrat));
%     hold on
% end
% xlabel('Engine Speed (RPM)')
% ylabel('Engine Torque (Nm)')
pwr_map = zeros([length(CTModel.eng_map_trq_bpt(10:end)) length(CTModel.eng_map_spd_bpt)]);
fuel_map = zeros([length(CTModel.eng_map_trq_bpt(10:end)) length(CTModel.eng_map_spd_bpt)]);
full_pwr_map = zeros([length(CTModel.eng_map_trq_bpt) length(CTModel.eng_map_spd_bpt)]);

% Engine Power Output
for i = 1:length(CTModel.eng_map_trq_bpt(10:end))
    for j = 1:length(CTModel.eng_map_spd_bpt)
        pwr_map(i,j) = CTModel.eng_map_trq_bpt(i+9,1) * CTModel.eng_map_spd_bpt(1,j) * 0.1047 * 0.001;
    end
end
fuel_map = CTModel.eng_fuel_map(10:end,1:end);

for i = 1:length(CTModel.eng_map_trq_bpt)
    for j = 1:length(CTModel.eng_map_spd_bpt)
        full_pwr_map(i,j) = CTModel.eng_map_trq_bpt(i,1) * CTModel.eng_map_spd_bpt(1,j) * 0.1047 * 0.001;
    end
end

figure;
for i = 1:n
    ax(i) = subplot(2,5,i);
    contourf((CTModel.eng_map_spd_bpt/(gvec(i)*fdrat))*...
        (CTModel.ld_tire_rad_m * 0.1047),(CTModel.eng_map_trq_bpt(10:end)*gvec(i)*fdrat),...
        pwr_map,'ShowText','on');
    hold on
    contour((CTModel.eng_map_spd_bpt/(gvec(i)*fdrat))*...
        (CTModel.ld_tire_rad_m * 0.1047),(CTModel.eng_map_trq_bpt(10:end)*gvec(i)*fdrat),...
        fuel_map,'ShowText','on','linewidth',2);
    scatter((CTModel.peak_eng_trq_spd_bpt/(gvec(i)*fdrat))*...
        (CTModel.ld_tire_rad_m * 0.1047),(CTModel.peak_eng_trq_map*gvec(i)*fdrat),...
        'filled','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
    xlabel('Vehicle Speed (m/s)')
    ylabel('Engine Torque (Nm)')
    title(strcat('Peak Engine Torque @ Gear : ',num2str(i)))
    grid on
end

figure;
contourf((CTModel.eng_map_spd_bpt)...
        ,(CTModel.eng_map_trq_bpt),...
        full_pwr_map,'ShowText','on');

