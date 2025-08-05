function [Dij,Dji,delij,delji,STDij,STDji] = smerova_korekce(Axy,Bxy,Ae,Be,Bro,Aro,As,Bs,pres)
%Výpočet směrové korekce
%vstup:
%   Axy-souřadnice bodu A [X,Y] v metrech
%   Bxy-souřadnice bodu B [X,Y] v metrech
%    Ae-polární úhel bodu A epsilon ve [° ' "], nebo v desetiné podobě [°]
%    Be-polární uhel bodu B epsilon ve [° ' "], nebo v desetiné podobě [°]
%   Bro-průvodič bodu B ró v metrech
%   Aro-průvodič bodu A ró v metrech
%    As-kartografická šířka S bodu A [° ' "], nebo v desetiné podobě [°]
%    Bs-kartografická šířka S bodu A [° ' "], nebo v desetiné podobě [°]
% [pres-přesnost výpočtu na desetinné místa] nepovinné
%výstup
%    Dij-směrová korekce pro spojnici AB v desetinné podobě [°]
%    Dji-směrová korekce pro spojnici BA v desetinné podobě [°]
%  delij-směrová korekce pro spojnici AB ve vteřinách ["]
%  delji-směrová korekce pro spojnici BA ve vteřinách ["]
%  STDij-směrová korekce pro spojnici AB ve [° ' "]
%  STDji-směrová korekce pro spojnici BA ve [° ' "]

%%
if length(Ae)~=1
    Ae=dms2deg(Ae);
end
if length(Be)~=1
    Be=dms2deg(Be);
end
if length(As)~=1
    As=dms2deg(As);
end
if length(Bs)~=1
    Bs=dms2deg(Bs);
end

 Q=[59, 42, 42.69689;42,31,31.41725];[Q]=dms2deg(Q);  %souřadnice kartografického pólu Q
 S0=[78,30,0];[S0]=dms2deg(S0);                       %základní kartografická rovnoběžka Š0

 Sij=sqrt((Axy-Bxy)*(Axy-Bxy)');
 epsIJ=(Ae+Be)/2; roij=(Bro+Aro)/2;
 smAB=atan2(Bxy(2)-Axy(2),Bxy(1)-Axy(1))/pi*180;
 if smAB<0
     smAB=smAB+360;
 end
 smBA=smAB-180;
 if smBA<0
     smBA=smBA+360;
 end
 Rii=180/pi*3600;
 ki=(sind(S0)-sind(As))/(6*sind(S0));
 kj=(sind(S0)-sind(Bs))/(6*sind(S0));

 
 delij=Rii*sind(Be-Ae)*(2*ki*(Bro/Aro)+kj*(Aro/Bro))+356*((Sij^3)/(roij)^3)*sin(3*((smAB-epsIJ)/180*pi));
 delji=Rii*sind(Ae-Be)*(2*kj*(Aro/Bro)+ki*(Bro/Aro))+356*((Sij^3)/(roij)^3)*sin(3*((smBA-epsIJ)/180*pi));
 if nargin~=8
     delij=round(delij,pres);
     delji=round(delji,pres);
 end
 Dij=delij/3600;
 Dji=delji/3600;

 [STDij]=deg2dms(Dij);
 [STDji]=deg2dms(Dji);


function [st]=dms2deg(v)
%převod stupňů, minut, vteřin na desetiné číslo
%vstup:
%   v-matice [s m v]
%vystup:
%   st-desetiné číslo
[r]=size(v,1);
st=ones(r,1);
for i=1:r
        if any(v(i,:)<0)
            Q=(-1);
        else
            Q=(1);
        end
        st(i,1)=(abs(v(i,1))+abs(v(i,2)/60)+abs(v(i,3)/3600))*Q;
end
end

function [v]=deg2dms(st)

%převod stupně v desetinné podobě ne matici
%vstup:
%   st-matice stupňů v desetinné podobě
%výstup:
%   v-matice [s m v]
r=length(st);
v=ones(r,3);
for i=1:r
    s=abs(fix(st(i,1)));
    m1=((abs(st(i,1))-abs(fix(st(i,1))))*60);
    m=fix(m1);
    vt=(m1-fix(m1))*60;
    v(i,1)=s;
    v(i,2)=m;
    v(i,3)=vt;
    if st(i,1)<0
        if s~=0
            v(i,1)=s*(-1);
        elseif s==0&&m~=0
            v(i,2)=m*(-1);
        else s==0&&m==0;
            v(i,3)=vt*(-1);
        end
    end
end

end

end