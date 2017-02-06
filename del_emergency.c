//
//  del_emergency.c
//  
//
//  Created by Thomas Gotke on 26/10/2016.
//
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "LOG.h"
char file[] = "del_emergency.c";
char module[] = "PD";

// ####### Global variables #######
double A[2] = {9.982119798660278, 57.01845375835744};
double B[2] = {9.982119798660278, 57.0184201700914};// coordinater {x,y}
double C[2] = {9.982398748397827, 57.01835155043711};
double D[2] = {9.982598748397827, 57.01846543924473};

double ABP;
double ADP;
double BCP;
double CDP;

double P[2]={9.00,57.00};
double areaSize;

void emergencyStop();

int main()
{
// The areal covered by the points A,B,C,D
areaSize = 0.5*fabs((A[1]-C[1])*(D[0]-B[0])+(B[1]-D[1])*(A[0]-C[0]));

// The area of the four triangles
ABP =0.5*fabs((A[0]*(B[1]-P[1]))+(B[0]*(P[1]-A[1]))+(P[0]*(A[1]-B[1])));
ADP =0.5*fabs((A[0]*(D[1]-P[1]))+(D[0]*(P[1]-A[1]))+(P[0]*(A[1]-D[1])));
BCP =0.5*fabs((B[0]*(C[1]-P[1]))+(C[0]*(P[1]-B[1]))+(P[0]*(B[1]-C[1])));
CDP =0.5*fabs((C[0]*(D[1]-P[1]))+(D[0]*(P[1]-C[1]))+(P[0]*(C[1]-D[1])));
double currentPositionSize = ABP + ADP + BCP + CDP;

if(currentPositionSize>areaSize)
{
    emergencyStop();
    LOG("ERROR","Robotic lawn mower outside perimeter!",file,module);
}
}


void emergencyStop()
{
// DO SOMETHING...
}