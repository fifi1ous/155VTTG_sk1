clc; clear; format long G

ss = load("pribl_sour_jtsk.txt");

gon2rad = pi/200;

[X_1002,Y_1002] = findPoint(ss, 1002);
[X_1001,Y_1001] = findPoint(ss, 1001);

st_2_sm_1 = 0         * gon2rad;
st_2_sm_ce = 86.7076  * gon2rad;
st_2_d_ce = 5.542;

st_2_sm_ci = 29.7071  * gon2rad;
st_2_d_ci = 5.248000000000000;

st_1_sm_2 = 200.1234  * gon2rad;
st_1_sm_ce = 217.1915 * gon2rad;
st_1_d_ce = 4.117;

st_1_sm_ci = 305.7122 * gon2rad;
st_1_d_ci = 3.456;

delka_ss = sqrt((X_1002-X_1001)^2 + (Y_1002-Y_1001)^2);
%% Příprava potřebných bodů
st_1001 = [ones(3,1)*Y_1001, ones(3,1)*X_1001];
st_1002 = [ones(3,1)*Y_1002, ones(3,1)*X_1002];

% vytvořené umělé souřadnice všech bodů - centr, excentrický cíl a
% excentrické stanovisko
%
% 1. centr                 [y,x;
% 2. excentrický cíl        y,x;
% 3. excentrické stanovisko y,x]

%% krok 1 - Výpočet souřadnic bodů na stanovisku kam cílíme - rajón zpět

w1 = st_1_sm_ce - st_1_sm_2;
w1(w1<0) = w1(w1<0) + 2*pi;

w2 = asin(sin(w1) / delka_ss * st_1_d_ce);

w3 = pi - (w1+w2);

sig_1 = atan2(st_1002(1,1)-st_1001(1,1),st_1002(1,2)-st_1001(1,2));
sig_1(sig_1<0) = sig_1(sig_1<0) + 2*pi;

st_1001(3,1) = st_1001(1,1) + st_1_d_ce * cos(sig_1);
st_1001(3,2) = st_1001(1,2) + st_1_d_ce * sin(sig_1);

sig_1 = atan2(st_1001(1,1)-st_1001(3,1),st_1001(1,2)-st_1001(3,2));
sig_1(sig_1<0) = sig_1(sig_1<0) + 2*pi;

st_1001(2,1) = st_1001(1,1) + st_1_d_ci * cos(sig_1);
st_1001(2,2) = st_1001(1,2) + st_1_d_ci * sin(sig_1);

%% krok 2 - 
