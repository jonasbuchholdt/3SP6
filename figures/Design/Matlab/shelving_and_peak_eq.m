%% Shelving and peak filters

clear all;

s = tf('s');

%% Shelving filter Low 1
om_zero = 30;
G = 2;
Hs_low_1 = 1+G*om_zero/(s+om_zero)

%% Shelving filter High 1
om_zero = 1/3000;
G = 2;
Hs_high_1 = 1+G*om_zero/(1/s+om_zero)

%% Shelving filter low 2
om_zero = 100;
G = 2;
Hs_low_2 = 1+G*om_zero/(s+om_zero)

%% Shelving filter High 2
om_zero = 1/10000;
G = 2;
Hs_high_2 = 1+G*om_zero/(1/s+om_zero)

%% Shelving filter low 3
om_zero = 500;
G = 2;
Hs_low_3 = 1+G*om_zero/(s+om_zero)

%% Shelving filter High 3
om_zero = 1/50000;
G = 2;
Hs_high_3 = 1+G*om_zero/(1/s+om_zero)

%% plotting
figure(1)
bodemag(Hs_low_1,Hs_low_2,Hs_low_3,Hs_high_1,Hs_high_2,Hs_high_3)
hold on
grid on
legend('Low omega1 = 30','Low omega1 = 100','Low omega1 = 500','High omega1 = 3000','High omega1 = 10000','High omega1 = 50000','Location','southwest')
% ylabel('Magnitude [dB]')
% xlabel('Frequency [rad/s]')
hold off
FigureToPDF(gcf,'low_and_high_shelfing')
% figure(2)
% bodemag(Hs_high_1,Hs_high_2,Hs_high_3)
% hold on
% grid on
% legend('omega1 = 30','omega1 = 100','omega1 = 500')
% % ylabel('Magnitude [dB]')
% % xlabel('Frequency [rad/s]')
% hold off
% FigureToPDF(gcf,'high_shelfing')
