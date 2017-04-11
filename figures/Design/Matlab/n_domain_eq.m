%% n-domain equalizer

clear all;

om_zero_sh = [100, 6400]*2*pi;
om_zero_peak = [200,400,800,1600,3200]*2*pi;
om_zero_pw = om_zero_peak;
om_zero_pw_sh = om_zero_sh;
Q = 1.4;
G1_peak = 0.4125;
G2_peak = 0.9952;
G3_peak = 1.8183;
G4_peak = 2.9810;
G5_peak = 4.6234;
G = G4_peak;

%insert your input in this table
filename = 'gtr-jazz-3.wav';%'16Hz-20kHz-Lin-CA-10sec.mp3';
[input, fs] = audioread(filename);
fs
Td = 1/fs;

% Generate sweep for simulation
t = 0:Td:10;
fo = 20;
f1 = 20000;
sweep = chirp(t,fo,10,f1,'logarithmic');

sample_no = length(input); %Length of the input
filter_no = 5;
output = zeros(sample_no,1);
y = zeros(sample_no,filter_no+1);
sweep = sweep.';
sweep_l = length(sweep);
sweep_out = zeros(sweep_l,1);
x = input;

for k = 1:5
b(1,k) = (4*Q+2*om_zero_pw(k)*Td+om_zero_pw(k)^2*Td^2*Q);
b(2,k) = (-8*Q+2*om_zero_pw(k)^2*Td^2*Q);
b(3,k) = (4*Q-om_zero_pw(k)*2*Td+om_zero_pw(k)^2*Td^2*Q);
a(1,k) = G*(om_zero_pw(k)*2*Td);
a(2,k) = 0;
a(3,k) = G*(-2*om_zero_pw(k)*Td); 
end

for j = 1:1:filter_no
%filter:
y(1,j) = a(1,j)/b(1,j)*x(1,1);
y(2,j) = a(1,j)/b(1,j)*x(2,1)-b(2,j)/b(1,j)*y(2-1,j);
for n = 3:1:sample_no
y(n,j) = a(1,j)/b(1,j)*x(n,1)+a(3,j)/b(1,j)*x(n-2,1)-b(2,j)/b(1,j)*y(n-1,j)-b(3,j)/b(1,j)*y(n-2,j); %peak 1
y(n,6) = y(n,6)+y(n,j);
end
end



audiowrite('outeq.wav',y(:,6),fs);
audiowrite('sweep.wav',sweep(:,1),fs);

% for plot:
clear y;
clear x;
y = zeros(sweep_l,filter_no+1);
x = zeros(sweep_l,filter_no+1);
x = sweep;
for j = 1:1:filter_no
%filter:
y(1,j) = a(1,j)/b(1,j)*x(1,1);
y(2,j) = a(1,j)/b(1,j)*x(2,1)-b(2,j)/b(1,j)*y(2-1,j);
sweep_out(1,1) = y(1,1)-sweep(1,1);
sweep_out(2,1) = y(2,1)-sweep(2,1);
for n = 3:1:sweep_l
y(n,j) = a(1,j)/b(1,j)*x(n,1)+a(3,j)/b(1,j)*x(n-2,1)-b(2,j)/b(1,j)*y(n-1,j)-b(3,j)/b(1,j)*y(n-2,j); %peak 1
y(n,6) = y(n,6)+y(n,j);
sweep_out(n,1) = x(n,1)-y(n,3);

end
end


%plot
figure(1)
hold on
grid on
plot(t,sweep_out(:,1),'b')
%plot(sweep(:,1),'r')
ylabel('Magnitude [V]')
xlabel('second')
hold off