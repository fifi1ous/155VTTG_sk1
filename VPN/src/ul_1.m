clc; clear; format long G

M1=Mereni_j(3,[14,30.5],22.4,[6.431;6.472;6.461;6.504;6.529]);
M2=Mereni_j(9,[14,49],22.4,[4.978;5.018;5.041;5.015;5.084]);
M3=Mereni_j(3,[15,10],22.6,[6.523;6.539;6.537;6.584;6.591]);
M4=Mereni_j(9,[15,35],22.6,[5.350;5.314;5.335;5.357;5.328]);
M5=Mereni_j(3,[15,53.5],22.6,[6.799;6.818;6.825;6.866;6.869]);
M6=Mereni_j(9,[16,10],22.6,[5.598;5.565;5.571;5.594;5.657]);

konst=4.379;
VGR=0.3086;
M=mereni_z([M1,M2,M3,M4,M5,M6],konst);
[TabPostup,TabVysledky,TabChod]=M.zpracuj(VGR);
M.vytvor_grafy();

TabPostup.Properties

TabVysledky.Properties

TabChod.Properties