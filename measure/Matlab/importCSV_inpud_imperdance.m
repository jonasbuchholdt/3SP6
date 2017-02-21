clear all;
filename = 'guitar_neck_and_bridge_picup.csv';
delimiterIn = ',';
headerlinesIn = 6;
A = importdata(filename,delimiterIn,headerlinesIn);

%dat = iddata(A.data(:,1),A.data(:,2));


for n = 1:5000
        ohm(n) = (A.data(n,3)/A.data(n,2))*9980;
end

figure
loglog(A.data(:,1),ohm(:))
axis([10 22000 1000 100000])
set(gca,'fontsize',18)
hold on
ylabel('Impedance [Ohm]')
xlabel('Frequency [Hz]')
hold off

