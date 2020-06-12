% This script is to assist with generating N number of randomized drive
% traces based on the average speed drive trace obtained from Google.

loadFile = 'Dec062019154949';
load(strcat(loadFile,'.mat'))
eval(['temp = ',loadFile,';'])

N = 10;     % Number of times a random drive trace needs to be generated
sz = N;

while (N > 0)
    [rand_time_s,rand_spd_mph(:,N)] = randomizeDrive(temp.time_s,temp.spd_mph,...
        0.25,5,'limit','normal');
    N = N - 1;
end

%% Plot
figure;
plot(temp.time_s,temp.spd_mph)
hold on
for i = 1:sz
    plot(rand_time_s,rand_spd_mph(:,i))
end
hold off