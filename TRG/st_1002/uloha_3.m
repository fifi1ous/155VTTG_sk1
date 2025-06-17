clc; clear; format long G

%% Anonymní funkce
rx = @(Alpha) [1, 0, 0; 0, cos(Alpha), sin(Alpha); 0, -sin(Alpha), cos(Alpha)];
ry = @(Beta)  [cos(Beta), 0, -sin(Beta); 0, 1, 0; sin(Beta), 0, cos(Beta)];
rz = @(Gama) [cos(Gama), sin(Gama), 0; -sin(Gama), cos(Gama), 0; 0, 0, 1];
cos_strana = @(b,c,alpha) acos(cos(b).*cos(c) + sin(b).*sin(c).*cos(alpha));
cos_uhel = @(a,b,c) acos((cos(a) - cos(b).*cos(c)) ./ (sin(b).*sin(c)));
%% Konstanty

hod2rad = pi/12;
gon2rad = pi/200;
deg2rad = pi/180;

% stanovisko - č. 5
st = [744940.536,   1040887.706];

% cíl - Norbert
cl = [745838.34,   1042134.49];

% Směrník
sig_ss = atan2(cl(1)-st(1),cl(2)-st(2));
if sig_ss < 0
    sig_ss = sig_ss+2 * pi;
end

% Měření 23.04.2025
%23.04.2025
% S0  h min s
S0 = [14 5 10.119];
% Ra    h min s
Ra23 = [2 3 30.3];
% Dec    °   '  "
Dec23 = [12 32 35];
%24.04.2025
% Ra    h min s
Ra24 = [2 7 15.9];
% Dec    °   '  "
Dec24 = [12 52 28];

% SELČ/SEČ
sec = 2;

q1 = 1.00273790935;
n = 37;
T2TT = 32.184;
DUT1 = 0;

% Měření soubory
mereni = {'LJhz1_14.m', 'LJhz2_14.m'};
%% Conversion
S0 = (S0(1) + S0(2)/60 + S0(3)/3600) * hod2rad;
Ra23 = (Ra23(1) + Ra23(2)/60 + Ra23(3)/3600) * hod2rad;
Dec23 = (Dec23(1) + Dec23(2)/60 +Dec23(3)/3600) * deg2rad;
Ra24 = (Ra24(1) + Ra24(2)/60 + Ra24(3)/3600) * hod2rad;
Dec24 = (Dec24(1) + Dec24(2)/60 + Dec24(3)/3600) * deg2rad;
n = n/3600 * hod2rad;
T2TT = T2TT/3600 * hod2rad;
DUT1 = DUT1/3600 * hod2rad;
sec = sec * hod2rad;

%% Měření
time  = [];
angle = [];

hzcilm = cell(1, numel(mereni));
hzsunm = cell(1, numel(mereni));

for i = 1:numel(mereni)
    [pom1, pom2] = loadData(mereni{i});
    

    hzcilm{i} = pom1;
    hzsunm{i} = pom2;

    time  = [time;  pom2(:,2)];
    angle = [angle; pom1 - pom2(:,1)];
end
angle(angle<0) = angle(angle<0) + 2 * pi;

UTC = time - sec;
TT = UTC + n +T2TT;

S = S0 + (UTC+DUT1) * q1;

[B,L,c]=jtsk2el(st(1),st(2));

% Interpolace dat
declination = interp1([0,2*pi],[Dec23,Dec24],TT,'linear');
r_ascention = interp1([0,2*pi],[Ra23,Ra24],TT,'linear');

t = S + L - r_ascention;
z = cos_strana(pi/2 - B,pi/2 - declination, t);
a = pi - cos_uhel(pi/2 - declination, z , pi/2 - B);

for i = 1:length(a)
    if t(i) > pi
        a(i) = 2 * pi - a(i);
    end
end

sig_ast  = a + c + angle + 10/3600*deg2rad;

sig_ast(sig_ast>2*pi) = sig_ast(sig_ast>2*pi)-2*pi;

% výsledky
[deg_all] = dec2dms((sig_ast-sig_ss)/deg2rad);
[deg_mean] = dec2dms((mean(sig_ast)-sig_ss)/deg2rad);


%% Funkce
function [hzcilm_1,hzsunm_1] = loadData(text)
    hod2rad = pi/24;
    gon2rad = pi/200;
    run(text)
    [hzcilm_1,hzsunm_1] = processData(hzcilm,hzsunm);
end

function [hzcilm_1,hzsunm_1] = processData(hzcilm,hzsunm)
    hod2rad = pi/12;
    gon2rad = pi/200;
    hzcilm = hzcilm *gon2rad;
    p2 = hzcilm(2) - pi;
    if p2 < 0 
        p2 = p2 +2*pi;
    end
    hzcilm_1 = (hzcilm(1) + p2) / 2;
    
    Time = ((hzsunm(:,2) + hzsunm(:,3)/60 + hzsunm(:,4) /3600)) * hod2rad;
    Angle = hzsunm(:,1) * gon2rad;
    Angle(2) = Angle(2) - pi;
    Angle(4) = Angle(4) - pi;
    Angle(Angle<0) = Angle(Angle<0) + 2 * pi;
    
    hzsunm_1 = [(Angle(1) + Angle(2))/2, (Time(1) + Time(2))/2; (Angle(3) + Angle(4))/2, (Time(3) + Time(4))/2];
end

function [B,L,c] = jtsk2el(Y,X)
    ro = pi/180;
    fi0 = 49.5*ro;
    S0 = 78.5*ro;
    a = 6377397.15508;
    e2 = 0.006674372230622;
    e = sqrt(e2);
    R = a*sqrt(1-e2)/(1-e2*sin(fi0)^2);
    ro0 = 0.9999*R/tan(S0);
    alfa = sqrt(1+e2*cos(fi0)^4/(1-e2));
    U0 = asin(sin(fi0)/alfa);
    k = (((1-e*sin(fi0))/(1+e*sin(fi0)))^(alfa*e/2)*tan(fi0/2 + pi/4)^alfa)/tan(U0/2 + pi/4);
    n = sin(S0);
    Uq = 59.71186025*ro;
    
    ro1 = sqrt(X^2+Y^2);
    eps = atan(Y/X);
    S = 2*atan((ro0/ro1)^(1/n)*tan(S0/2 + pi/4)) - pi/2; D = eps/sin(S0);
    U = asin(sin(Uq)*sin(S)-cos(Uq)*cos(S)*cos(D));
    dV = asin(sin(D)*cos(S)/cos(U));
    L = 24.833333333333*ro - dV/alfa;
    B = U; B0 = Inf; i = 0;
    while abs(B-B0) > 1e-12
        B0 = B;
        B = 2*atan(k^(1/alfa)*((1-e*sin(B0))/(1+e*sin(B0)))^(-e/2)*tan(U/2 + pi/4)^(1/alfa))-pi/2;
        i = i+1;
    end
    gamma = st_sus(pi/2-Uq,dV,pi/2-U);
    c = eps-gamma;
end

function [alfa,c,beta] = st_sus(a, gamma, b)
    %ST_SUS function [alfa,c,beta] = st_sus(a,gamma,b)
    %Vypocte zbyle prvky sferickeho trojuhelnika ze 2 zadanych stran a uhlu jimi sevrenem [rad]
    %IN: a, gamma, b [rad]
    %OUT: alfa, c, beta [rad]
    
    % Vytvořil: Matěj Klimeš
    % Datum: 1.10.2023
    
    c = acos(cos(a)*cos(b)+sin(a)*sin(b)*cos(gamma));
    alfa = acos((cos(a)-cos(b)*cos(c))/(sin(b)*sin(c)));
    beta = acos((cos(b)-cos(a)*cos(c))/(sin(a)*sin(c)));

end

function [deg] = dec2dms(decimalDeg)
%DEC2DMS Converts decimal degrees to degrees, minutes, and seconds.
%   Input:
%       decimalDeg - Decimal degree value (can be scalar, vector, positive or negative)
%   Output:
%       degOut - Degrees (integer part, sign preserved)
%       minOut - Minutes (always positive)
%       secOut - Seconds (always positive)

    % Preserve sign for degrees
    signVal = sign(decimalDeg);
    absDeg = abs(decimalDeg);

    % Extract degrees
    degOut = fix(absDeg) .* signVal;

    % Calculate minutes
    remainderMin = (absDeg - fix(absDeg)) * 60;
    minOut = fix(remainderMin);

    % Calculate seconds
    secOut = (remainderMin - minOut) * 60;

    deg = [degOut, minOut, secOut];
end

