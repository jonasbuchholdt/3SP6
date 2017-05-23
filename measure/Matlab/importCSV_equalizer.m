clear all;
filename = '../peak_200Hz.csv';
delimiterIn = ',';
headerlinesIn = 6;
A = importdata(filename,delimiterIn,headerlinesIn);
filename = '../peak_400Hz.csv';
B = importdata(filename,delimiterIn,headerlinesIn);
filename = '../peak_800Hz.csv';
C = importdata(filename,delimiterIn,headerlinesIn);
filename = '../peak_1600Hz.csv';
D = importdata(filename,delimiterIn,headerlinesIn);
filename = '../peak_3200Hz.csv';
E = importdata(filename,delimiterIn,headerlinesIn);
filename = '../shelving_100Hz.csv';
F = importdata(filename,delimiterIn,headerlinesIn);
filename = '../shelving_6400Hz.csv';
G = importdata(filename,delimiterIn,headerlinesIn);

%dat = iddata(A.data(:,1),A.data(:,2));


figure
semilogx(A.data(:,1),A.data(:,3),A.data(:,1),B.data(:,3),A.data(:,1),C.data(:,3),A.data(:,1),D.data(:,3),A.data(:,1),E.data(:,3),A.data(:,1),F.data(:,3),A.data(:,1),G.data(:,3))
axis([20 20000 -20 10])
set(gca,'fontsize',18)
hold on
grid on
ylabel('Magnitude [dB]')
xlabel('Frequency [Hz]')
hold off

%FigureToPDF(gcf, '../opamp_zi_v0')

