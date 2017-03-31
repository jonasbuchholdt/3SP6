%% z-domain equalizer
clear all;
format long g;
Fs = 44100;
Fp = 44100;
Td = 1/Fs;
om_zero_sh = [100, 6400];
om_zero_peak = [200,400,800,1600,3200];
%om_zero_pw = 2/Td*tan(om_zero/2)
%om_zero_pw = 2*atan(om_zero*Td/2)
om_zero_pw = 2*Fs*tan(om_zero_peak/(2*Fs));
om_zero_pw_sh = 2*Fs*tan(om_zero_sh/(2*Fs));
Q = 1.6;
G = 4.6234;
s = tf('s');
z = tf('z',Td);
a = zeros(3,5);
b = zeros(3,5);
c = zeros(2,2);
d = zeros(2,2);

%Low Shelving coefficients
c(1,1) = 2+om_zero_pw_sh(1)*Td*(G+1);
c(2,1) = -2+om_zero_pw_sh(1)*(G+1)*Td;
d(1,1) = 2+om_zero_pw_sh(1)*Td;
d(2,1) = -2+om_zero_pw_sh(1)*Td;

%High Shelving coefficients
c(1,2) = 2*(G+1)+om_zero_pw_sh(2)*Td;
c(2,2) = -2*(G+1)+om_zero_pw_sh(2)*Td;
d(1,2) = 2+om_zero_pw_sh(2)*Td;
d(2,2) = -2+om_zero_pw_sh(2)*Td;
 

%Peak coefficients 
for k = 1:5
b(1,k) = Q*4+om_zero_pw(k)*2*Td+Q*om_zero_pw(k)^2*Td^2;
b(2,k) = (-Q*8+2*Q*om_zero_pw(k)^2*Td^2)
b(3,k) = (Q*4-om_zero_pw(k)*2*Td+Q*om_zero_pw(k)^2*Td^2)
a(1,k) = (Q*4+(G+1)*2*om_zero_pw(k)*Td+Q*om_zero_pw(k)^2*Td^2)
a(2,k) = (-Q*8+2*Q*om_zero_pw(k)^2*Td^2)
a(3,k) = (Q*4-(G+1)*om_zero_pw(k)*2*Td+Q*om_zero_pw(k)^2*Td^2)
end

%Low shelving filter
H_z_LS = (z*c(1,1)+c(2,1))/(z*d(1,1)+d(2,1));

%Peak 1
H_z1 = (z^2*a(1,1)+z*a(2,1)+a(3,1))/(z^2*b(1,1)+z*b(2,1)+b(3,1))

%Peak 2
H_z2 = (z^2*a(1,2)+z*a(2,2)+a(3,2))/(z^2*b(1,2)+z*b(2,2)+b(3,2))

%Peak 3
H_z3 = (z^2*a(1,3)+z*a(2,3)+a(3,3))/(z^2*b(1,3)+z*b(2,3)+b(3,3))

%Peak 4
H_z4 = (z^2*a(1,4)+z*a(2,4)+a(3,4))/(z^2*b(1,4)+z*b(2,4)+b(3,4))

%Peak 5
H_z5 = (z^2*a(1,5)+z*a(2,5)+a(3,5))/(z^2*b(1,5)+z*b(2,5)+b(3,5))

%High shelving filter
H_z_HS = (z*c(1,2)+c(2,2))/(z*d(1,2)+d(2,2));

H_z_01 = H_z4+H_z5+H_z_HS;
H_z_02 = 1+H_z2+H_z3+H_z4;
H_z_03 = H_z_LS+H_z1+H_z2;
H_z = 1+H_z1+H_z2+H_z3+H_z_LS


% Plot
% figure(1)
% bodemag(H_z1,{0.1,10^6})
% 
% figure(2)
% bodemag(H_z2,{0.1,10^6})
% 
% figure(3)
% bodemag(H_z3,{0.1,10^6})
% 
% figure(4)
% bodemag(H_z4,{0.1,10^6})
% 
% figure(5)
% bodemag(H_z5,{0.1,10^6})
% 
% figure(6)
% bodemag(H_z_LS,{0.1,10^6})
% 
% figure(7)
% bodemag(H_z_HS,{0.1,10^6})

figure(8)
bodemag(H_z_LS,H_z1,H_z2,H_z3,H_z4,H_z5,H_z_HS,H_z,{0.1,10^6})

