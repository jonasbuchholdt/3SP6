clear all;
filename = '../opamp_zo_v2.csv';
delimiterIn = ',';
headerlinesIn = 6;
A = importdata(filename,delimiterIn,headerlinesIn);

%dat = iddata(A.data(:,1),A.data(:,2));


figure
plot(A.data(:,1),A.data(:,2))
axis([-6*10^(-3) 6*10^(-3) -1 1])
set(gca,'fontsize',18)
hold on
grid on
ylabel('Magnitude [V]')
xlabel('Time [S]')
hold off
