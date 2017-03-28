%% z-domain equalizer
clear all;
Fs = 44100;
Fp = 44100;
Td = 1/Fs;
om_zero = 100;
om_zero_pw = 2/Td*tan(om_zero/2)
om_zero_pw = om_zero
Q = 1.6;
G = 4.6234;
s = tf('s');
z = tf('z',Td);
a1 = Q*4+(G+1)*om_zero_pw^2*Td+Q*om_zero_pw^2*Td^2
a2 = -Q*8+2*Q*om_zero_pw^2*Td^2
a3 = Q*4-(G+1)*om_zero_pw*2*Td+Q*om_zero_pw^2*Td^2
b1 = Q*4+om_zero_pw*2*Td+Q*om_zero_pw^2*Td^2
b2 = -Q*8+2*Q*om_zero_pw^2*Td^2
b3 = Q*4-om_zero_pw*2*Td+Q*om_zero_pw^2*Td^2
numd1 = [a1 a2 a3];
dend1 = [b1 b2 b2];
%H_z = (z^2*a1+z*a2+a3)/(z^2*b1+z*b2+b3)
H_z = tf([numd1],[dend1],Td,'variable','z')

Hs = 1/(om_zero*Q);
num = [Q (G*om_zero+om_zero) Q*om_zero^2];
den = [Q om_zero Q*om_zero^2];
[numd2,dend2] = bilinear(num,den,Fs); 
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_LP_d = tf([numd2],[dend2],Td,'variable','z');
H_BP_1d = H_LP_d

numd3 = [1.003 -1.999 0.9953];
dend3 = [1 -1.999 0.9986];

%H_z2 = (1.003*z^2-1.999*z+0.9953)/(z^2-1.999*z+0.9986)
H_z2 = tf([numd3],[dend3],Td,'variable','z')

figure(1)
bodemag(H_BP_1d)

figure(2)
bodemag(H_z)

figure(3)
bodemag(H_z2)