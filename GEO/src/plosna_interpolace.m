function [X]=plosna_interpolace(B,L,X1,B1,L1,X2,B2,L2,X3,B3,L3,X4,B4,L4)

R = 6371000;
B = B  * (pi/180);

delta_L = (L - L1) * (pi/180);
B1 = B1  * (pi/180);
d1 = R * acos(sin(B) * sin(B1) + cos (B) * cos(B1) * cos(delta_L));
p1 = 1/d1;

delta_L = (L - L2) * (pi/180);
B2 = B2  * (pi/180);
d2 = R * acos(sin(B) * sin(B2) + cos (B) * cos(B2) * cos(delta_L));
p2 = 1/d2;

delta_L = (L - L3) * (pi/180);
B3 = B3  * (pi/180);
d3 = R * acos(sin(B) * sin(B3) + cos (B) * cos(B3) * cos(delta_L));
p3 = 1/d3;

delta_L = (L - L4) * (pi/180);
B4 = B4  * (pi/180);
d4 = R * acos(sin(B) * sin(B4) + cos (B) * cos(B4) * cos(delta_L));
p4 = 1/d4;

X = ((X1 * p1) + (X2 * p2) + (X3 * p3) + (X4 * p4))/(p1 + p2 + p3 + p4);
