%% Minimum ripple shelving and peak filters

clear all;

s = tf('s');

min_ripple = 50;

for j = 1:300

% Shelving filter Low 
om_zero = 100;
G = 5.7355;
s_LS = s/om_zero;
Hs = (s_LS^2+sqrt(2*G)*s_LS+G)/(s_LS^2+sqrt(2)*s_LS+1);
Hs_low = Hs;

% Shelving filter High 
om_zero = 6400;
%G = 2;
s_HS = om_zero/s;
Hs = (s_HS^2+sqrt(2*G)*s_HS+G)/(s_HS^2+sqrt(2)*s_HS+1);
Hs_high = Hs;

% Peak filter 1
om_zero = 200;
G = 4.6234;
Q = 0.9+0.1*j;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_1 = 1+G*H_LP*Hs;

% Peak filter 2
om_zero = 400;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_2 = 1+G*H_LP*Hs;

% Peak filter 3
om_zero = 800;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_3 = 1+G*H_LP*Hs;

% Peak filter 4
om_zero = 1600;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_4 = 1+G*H_LP*Hs;

% Peak filter 5
om_zero = 3200;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_5 = 1+G*H_LP*Hs;

H = H_BP_1*H_BP_2*H_BP_3*H_BP_4*H_BP_5*Hs_low*Hs_high;

% Finding ripple
fband = [200,3200];
[gpeak,fpeak] = getPeakGain(H,0.01,fband);
[gmin,fmin] = getPeakGain(H^(-1),0.01,fband);
Maximum = 20*log10(gpeak);
Minimum = 20*log10(gmin);
ripple = Maximum-abs(Minimum);
if (ripple <= min_ripple)
    H_final = H;
    H_final_BP_1 = H_BP_1;
    H_final_BP_2 = H_BP_2;
    H_final_BP_3 = H_BP_3;
    H_final_BP_4 = H_BP_4;
    H_final_BP_5 = H_BP_5;
    j;
    min_ripple = ripple;
    Q_final = Q;
end
end
min_ripple
Q_final
%% plotting
figure(1)
%bodemag(Hs_low_1,Hs_low_2,Hs_low_3,Hs_high_1,Hs_high_2,Hs_high_3)

bodemag(Hs_low,H_final_BP_1,H_final_BP_2,H_final_BP_3,H_final_BP_4,H_final_BP_5,H_final,Hs_high,H_final^(-1))
hold on
grid on
legend('Peak filter G = 6','Peak filter G = 3','Peak filter G = 1','High omega1 = 3000','High omega1 = 10000','High omega1 = 50000','Location','southwest')
% ylabel('Magnitude [dB]')
% xlabel('Frequency [rad/s]')
hold off