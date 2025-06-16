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