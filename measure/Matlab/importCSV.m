clear all;
filename = '\Users\Sebatian\3SP6\measure\guitar_low_E_neck.csv';
delimiterIn = ',';
headerlinesIn = 6;
A = importdata(filename,delimiterIn,headerlinesIn);

dat = iddata(A.data(:,1),A.data(:,2));

figure
semilogx(A.data(:,1),A.data(:,2))
axis([20 20000 -140 -20])
set(gca,'fontsize',18)
hold on
ylabel('Magnitude [dB]')
xlabel('Frequency [Hz]')
hold off

