   %W = -pi:(2*pi)/8192:pi;
   %[H,W] = fvtool([1 -1],[1 0.9]);
   %plot(W,abs(H));  
   %x(n-Delay(1),1)+(x(n-Delay(1)*2,2))*g;
   
   
   
   %y[n] = -0.9y[n-1] +x [n] -x [n-1]
   %fvtool([1 -1],[1 0.9]);
   
   %x2[n]-ax2[n-2]=1*x1[n-1]
  a = [1 -0.2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -0.6]; %y
  b = [1 -0.2]; %x
   fvtool(b,a);
   
%fs = 44100;
%f0 = 220;
%M = round(fs/f0);
%g = 0.9;
%B = 1;
%A = [1 zeros(1, M-1) g];
%fvtool(B, A);
