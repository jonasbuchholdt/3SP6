clear all

n = 0;
Y = 1;


while Y > 0.0011
   n = n+1;
   Y = 1*0.708^n;
   
   k = 0;
   X = 1;
   while X > 0.0011
   k = k+1;
   X = Y*0.708^k;
   end
   k
   
end

n