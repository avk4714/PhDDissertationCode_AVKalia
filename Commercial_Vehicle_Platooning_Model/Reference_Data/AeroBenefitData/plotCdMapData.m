%% Plot Cd Map Data
%% Two Truck Platoon
figure;
plot(d_11,Cd_Map_T2(:,1))
hold on
plot(d_11,Cd_Map_T2(:,2))
grid on
legend('Lead Truck','Tail Truck')
xlabel('Inter-Truck Distance (Lead - Tail) [m]')
ylabel('Drag Coefficient, C_{d,avg} [-]')

%% Three Truck Platoon
figure;
surfc(d_11,d_22,Cd_Map(:,:,1))
xlabel({'Inter-Truck Distance';'(Lead - Middle) [m]'})
ylabel({'Inter-Truck Distance';'(Middle - Tail) [m]'})
zlabel('Drag Coefficient, C_{d,avg} [-]')

figure;
surfc(d_11,d_22,Cd_Map(:,:,2))
xlabel({'Inter-Truck Distance';'(Lead - Middle) [m]'})
ylabel({'Inter-Truck Distance';'(Middle - Tail) [m]'})
zlabel('Drag Coefficient, C_{d,avg} [-]')

figure;
surfc(d_11,d_22,Cd_Map(:,:,3))
xlabel({'Inter-Truck Distance';'(Lead - Middle) [m]'})
ylabel({'Inter-Truck Distance';'(Middle - Tail) [m]'})
zlabel('Drag Coefficient, C_{d,avg} [-]')