clc; clear; format long G

M1=Mereni_j(3408,[9,55.5],20.2,[12.004; 12.075; 12.063; 12.103]);
M2=Mereni_j(34,[11,17.5],20.1,[11.485; 11.449; 11.425; 11.454; 11.454]);
M3=Mereni_j(35,[10,54.5],20.1,[10.564; 10.522; 10.537; 10.492]);
M4=Mereni_j(36,[10,28],20.1,[10.039; 10.065; 10.066; 10.028; 10.051]);
M5=Mereni_j(3408,[11,32.30],20.1,[12.400; 12.345; 12.349; 12.385; 12.349]);

konst=4.379;
VGR=0.3086;
M=mereni_z([M1,M2,M3,M4,M5],konst);
[TabPostup,TabVysledky,TabChod]=M.zpracuj(VGR);
M.vytvor_grafy();

TabPostup.Properties

TabVysledky.Properties

TabChod.Properties