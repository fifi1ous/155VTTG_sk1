function [sig_ast] = astronomical_azimuth(st,time,angle,S0_,Ra23,Dec23,Ra24,Dec24,sec,q1,n,T2TT,DUT1)
%% Anonymní funkce
cos_strana = @(b,c,alpha) acos(cos(b).*cos(c) + sin(b).*sin(c).*cos(alpha));
cos_uhel = @(a,b,c) acos((cos(a) - cos(b).*cos(c)) ./ (sin(b).*sin(c)));
%% Konstanty

hod2rad = pi/12;
gon2rad = pi/200;
deg2rad = pi/180;

if length(time)>1
    time = ((time(1) + time(2)/60 + time(3) /3600)) * hod2rad;
else
    time = time * hod2rad;
end
angle = angle * gon2rad;

%% Conversion
S0_ = (S0_(1) + S0_(2)/60 + S0_(3)/3600) * hod2rad;
Ra23 = (Ra23(1) + Ra23(2)/60 + Ra23(3)/3600) * hod2rad;
Dec23 = (Dec23(1) + Dec23(2)/60 +Dec23(3)/3600) * deg2rad;
Ra24 = (Ra24(1) + Ra24(2)/60 + Ra24(3)/3600) * hod2rad;
Dec24 = (Dec24(1) + Dec24(2)/60 + Dec24(3)/3600) * deg2rad;
n = n/3600 * hod2rad;
T2TT = T2TT/3600 * hod2rad;
DUT1 = DUT1/3600 * hod2rad;
sec = sec * hod2rad;

UTC = time - sec;
TT = UTC + n +T2TT;

S_ = S0_ + (UTC+DUT1) * q1;

[B,L,c]=jtsk2el(st(1),st(2));

% Interpolace dat
declination = interp1([0,2*pi],[Dec23,Dec24],TT,'linear');
r_ascention = interp1([0,2*pi],[Ra23,Ra24],TT,'linear');

t = S_ + L - r_ascention;

 z = cos_strana(pi/2 - B,pi/2 - declination, t);
a_ = pi - cos_uhel(pi/2 - declination, z , pi/2 - B);

if t > pi
    a_ = 2 * pi - a_;
end

sig_ast  = a_ + c + angle + 10/3600*deg2rad;

sig_ast(sig_ast>2*pi) = sig_ast(sig_ast>2*pi)-2*pi;

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
end