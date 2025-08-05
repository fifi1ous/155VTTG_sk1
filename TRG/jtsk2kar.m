function [S,D,R,D_] = jtsk2kar(Y,X)
    %% Constants
    ro = pi/180;
    S0 = (78 + 30/60).*ro;
    r = 6380703.6105;

    R0 = 0.9999.*r.*(cos(S0)./sin(S0));
    
    n=sin(S0);
    %%

    R = sqrt(X.^2+Y.^2);
    D_ = atan2(Y,X);

    S = 2*(atan(tan(S0./2+pi./4).*(R0./R).^(1/n))-pi/4);
    D = D_./sin(S0);
end