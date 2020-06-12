% Plot to compare results from speed variation
%% Plot for NetEC_opt
figure(1)
for i = 4:4:12
    eval(['bar(',int2str(i),',Nov202019181621.spdVar.NetOC_opt.comb_',int2str(i),')'])
    hold on
end
plot(linspace(1,12,12),ones([1 12]) * Nov202019181621.spdVar.NetOC_opt.base,'color','k')
hold off
grid on
makePublishable(0)

%% Plot SOC_opt
figure(2)
for i = 4:4:12
    eval(['plot(Nov202019181621.time_s,Nov202019181621.spdVar.SOC_opt.comb_',int2str(i),')'])
    hold on
end
plot(Nov202019181621.time_s,Nov202019181621.spdVar.SOC_opt.base,'color','k')
hold off
grid on
makePublishable(0)