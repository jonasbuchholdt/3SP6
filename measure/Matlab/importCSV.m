clear all;
filename = 'ppeak_voltage.csv';
delimiterIn = ',';
headerlinesIn = 6;
A = importdata(filename,delimiterIn,headerlinesIn);

%dat = iddata(A.data(:,1),A.data(:,2));

figure
plot(A.data(:,1),A.data(:,2))
axis([-1 1 -1 1])
set(gca,'fontsize',18)
hold on
grid on
ylabel('Magnitude [V]')
xlabel('Time [S]')
hold off

