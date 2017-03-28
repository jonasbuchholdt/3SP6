clear all
close all
%Delay Effect
%Group 641


%insert your input in this table
filename = 'guitartune.wav';%'16Hz-20kHz-Lin-CA-10sec.mp3';
[input, fs] = audioread(filename);
fs

%user define array and variable
g = 0.7; %Gain
time = 10; % roomsize
early = 2; % pre delay
scaleroom = 0.99; %0.28 int
drywet = 1; % dry/wet

%Pre define array and variable
b = [1,0.9,0.8,0.7,0.6,0.5];
iirg = 0.2;

% filter delay time 
Delay = [round(fs/1000*1.9*time),round(fs/1000*2.3*time),round(fs/1000*2.9*time),round(fs/1000*3.1*time),round(fs/1000*3.7*time),round(fs/1000*4.1*time),round(fs/1000*1.7*time),round(fs/1000*1.3*time)]
Early_delay = [round(fs/1000*1.01*time*early),round(fs/1000*1.99*time*early),round(fs/1000*3.07*time*early),round(fs/1000*4.01*time*early)]
row = length(Delay) %total-1 array row.
d_out = (round(length(Delay)*g)+time); %total samples after the input is finist 
d = sum(Delay); %total delay time.

%making the array for sampels
sample_no = length(input); %Length of the input
x = zeros(row+1,round(sample_no+(d*d_out*g)))';
y = zeros(row+1,round(sample_no+(d*d_out*g)))';
w = zeros(row+1,round(sample_no+(d*d_out*g)))';
in = zeros(row+1,round(sample_no+(d*d_out*g)))';

%move all input data the total delay time to the left 
for i = 1:1:sample_no
    in(i+d+1,1) = input(i,1)';
end
%Making the Moorer reverb
for n = 1:1:sample_no+(d*d_out*g)-d-1
    n = n+d+1;
    
    % Early reflection network
    x(n,1) = in(n,1) + in(n-Early_delay(1),1) + in(n-Early_delay(2),1) + in(n-Early_delay(3),1)+ in(n-Early_delay(4),1);
   
    %x(n,2) = x(n-Delay(1),1)+(x(n-Delay(1)+Delay(1),2))*g;
    %x(n,3) = x(n-Delay(2),1)+(x(n-Delay(2)+Delay(2),3))*g;
    %x(n,4) = x(n-Delay(3),1)+(x(n-Delay(3)+Delay(3),4))*g;
    %x(n,5) = x(n-Delay(4),1)+(x(n-Delay(4)+Delay(4),5))*g;
    %x(n,6) = x(n-Delay(5),1)+(x(n-Delay(5)+Delay(5),6))*g;
    %x(n,7) = x(n-Delay(6),1)+(x(n-Delay(6)+Delay(6),7))*g;
    
    %x(n,2) = x(n,1)-iirg*x(n-1,1)+iirg*x(n-1,2)+(g*(1-iirg)*x(n-Delay(1),2));
    %x(n,3) = x(n,1)-iirg*x(n-1,1)+iirg*x(n-1,3)+(g*(1-iirg)*x(n-Delay(2),3));
    %x(n,4) = x(n,1)-iirg*x(n-1,1)+iirg*x(n-1,4)+(g*(1-iirg)*x(n-Delay(3),4));
    %x(n,5) = x(n,1)-iirg*x(n-1,1)+iirg*x(n-1,5)+(g*(1-iirg)*x(n-Delay(4),5));
    %x(n,6) = x(n,1)-iirg*x(n-1,1)+iirg*x(n-1,6)+(g*(1-iirg)*x(n-Delay(5),6));
    %x(n,7) = x(n,1)-iirg*x(n-1,1)+iirg*x(n-1,7)+(g*(1-iirg)*x(n-Delay(6),7));
    
    
    % Late reflection network
    
    w(n,1) = x(n,1) + iirg*w(n-1,1);
    x(n,2) = w(n,1)-iirg*w(n-1,1)+((0.5*scaleroom+g)*(1-iirg)*x(n-Delay(1),2));
    
    w(n,2) = x(n,1) + iirg*w(n-1,2);
    x(n,3) = w(n,2)-iirg*w(n-1,2)+((0.5*scaleroom+g)*(1-iirg)*x(n-Delay(2),3));
    
    w(n,3) = x(n,1) + iirg*w(n-1,3);
    x(n,4) = w(n,3)-iirg*w(n-1,3)+((0.5*scaleroom+g)*(1-iirg)*x(n-Delay(3),4));
    
    w(n,4) = x(n,1) + iirg*w(n-1,4);
    x(n,5) = w(n,4)-iirg*w(n-1,4)+((0.5*scaleroom+g)*(1-iirg)*x(n-Delay(4),5));
    
    w(n,5) = x(n,1) + iirg*w(n-1,5);
    x(n,6) = w(n,5)-iirg*w(n-1,5)+((0.5*scaleroom+g)*(1-iirg)*x(n-Delay(5),6));
    
    w(n,6) = x(n,1) + iirg*w(n-1,6);
    x(n,7) = w(n,6)-iirg*w(n-1,6)+((0.5*scaleroom+g)*(1-iirg)*x(n-Delay(6),7));
    
    x(n,8) = x(n,2)*b(1) + x(n,3)*b(2) + x(n,4)*b(3) + x(n,5)*b(4) + x(n,6)*b(5) + x(n,7)*b(6);
    
    w(n,8) = g * w(n-Delay(7),8) + x(n,8);
    x(n,9) = -g * w(n,8) + w(n-Delay(7),8);  
    
    w(n,9) = g * w(n-Delay(8),9) + x(n,9);
    y(n) = ((in(n,1)*(1-drywet/1))+((-g * w(n,9) + w(n-Delay(8),9)))*drywet);
end

% keeps the output of maximum a gain of one.
maximum = 1 / max(abs(y(:,1)));
y(:,1) = y(:,1)*maximum*0.98;


%write and plot
audiowrite('outfa.wav',y(:,1),fs);
plot(in(:,1),'b')
hold on
grid on
plot(y(:,1),'r')
%semilogx(x(:,9),'g')
ylabel('Magnitude [V]')
xlabel('sample')
FigureToPDF(gcf, '../../figures/design/reverb')