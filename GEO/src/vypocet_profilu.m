clear all;
clc;
format short g

kvazigeoid

body = [
23        50.164087503	16.9462487	   568.2806   19.0  	524.507      0.0
25        50.167513962	16.945161394	582.7106   19.0 	538.941      0.0
27.1      50.176504971	16.939534398	588.4951   19.0   544.738      2.0
29        50.179158787	16.932854631	598.3384   19.0   554.575      1.0
30        50.180467655	16.925359149	610.1911   19.0  	566.417      0.0
31        50.186655344	16.921240283	624.8572   19.0  	581.028      1.0
31.1      50.190643622	16.919345029	635.6977   19.0   591.914      1.0
32        50.193389927	16.919157787	643.4787   19.0   599.737      0.0
33.1	    50.198561987	16.9175195365	658.5712    9.3  	614.8535     5.1
34	       50.203435363	16.9153540595	676.09175   2.9 	632.371      1.0
35.1	    50.2085501605	16.919424369	699.45595  24.0	655.705      0 % zde je 0 jelikož nebylo nivelováno
36.1	    50.2110209295	16.920656845	711.6856   18.0	667.927      0
37	       50.2161002475	16.9215535125	740.65485  43.0	696.922      0.0
39.1	    50.2181738685	16.9256678875	771.63845  18.1	727.9305     0.0
43	       50.219690794	16.925238705	828.41785  29.4	784.740      1.0
44	       50.223026149	16.9236326395	845.4137    7.6 	801.7975     1.4
]; % za smdch u gnss výšky dáme 19.0 jakožto průměr z smdch na dvakrát měřených bodech


c_bodu_vec = [];
N_vec = [];
N_mervec = [];
i_vec = [];
r_vec = [];
sigma_vec = [];

B = body(1,2);
L = body(1,3);
R = 6380000;

for i = 1 : size(body,1)
  i_vec = [i_vec; i];

  c_bodu = body(i,1);
  c_bodu_vec = [c_bodu_vec; c_bodu];

%  Bi = body(i,2) + body(i,3)/60 + body(i,4)/3600;
%  Li = body(i,5) + body(i,6)/60 + body(i,7)/3600;
%  Hi = body(i,8);
%  Hi_sigma = body(i,9);
%  hi_niv = body(i,10);
%  hi_niv_sigma = body(i,11);

  Bi = body(i,2);
  Li = body(i,3);
  Hi = body(i,4);
  Hi_sigma = body(i,5);
  hi_niv = body(i,6);
  hi_niv_sigma = body(i,7);

  [N1,B1,L1,N2,B2,L2,N3,B3,L3,N4,B4,L4]=nejblizsi4(Bi,Li,3,kvazigeoid1);
  [N]=plosna_interpolace(Bi,Li,N1,B1,L1,N2,B2,L2,N3,B3,L3,N4,B4,L4);

  N_vec = [N_vec; N];

  N_mer = Hi - hi_niv;
  N_mervec = [N_mervec; N_mer];

  deltaL = Li - L;
  r = R * acos(sin(B * pi / 180) * sin(Bi * pi / 180) + cos (B * pi / 180) * cos(Bi * pi / 180) * cos(deltaL * pi / 180));
  r_vec = [r_vec; r];

  sigma = sqrt(Hi_sigma^2 + hi_niv_sigma^2);
  sigma_vec = [sigma_vec; sigma];
end

[i_vec r_vec c_bodu_vec N_vec N_mervec N_vec-N_mervec sigma_vec]

plot(r_vec, N_vec, 'b', 'LineWidth', 1.2);           % červená čára
hold on
plot(r_vec, N_mervec, 'g', 'LineWidth', 1.2);        % zelená čára
plot(r_vec, N_mervec, '.', 'MarkerSize', 8);        %
%errorbar(r_vec, N_mervec, sigma_vec/2);

legend('model kvazigeoidu CR2005', ...
       'měřená data', ...
       'observační bod');


text(r_vec(1)+50, N_mervec(1)+0.0, num2str(c_bodu_vec(1)),'Color','k')
text(r_vec(2)+50, N_mervec(2)+0.0, num2str(c_bodu_vec(2)),'Color','k')
text(r_vec(3)+50, N_mervec(3)+0.0, num2str(c_bodu_vec(3)),'Color','k')
text(r_vec(4)+50, N_mervec(4)+0.0, num2str(c_bodu_vec(4)),'Color','k')
text(r_vec(5)+50, N_mervec(5)+0.0, num2str(c_bodu_vec(5)),'Color','k')
text(r_vec(6)+50, N_mervec(6)+0.0, num2str(c_bodu_vec(6)),'Color','k')
text(r_vec(7)+50, N_mervec(7)+0.0, num2str(c_bodu_vec(7)),'Color','k')
text(r_vec(8)+50, N_mervec(8)+0.0, num2str(c_bodu_vec(8)),'Color','k')
text(r_vec(9)+50, N_mervec(9)+0.0, num2str(c_bodu_vec(9)),'Color','k')
text(r_vec(10)+50, N_mervec(10)+0.0, num2str(c_bodu_vec(10)),'Color','k')
text(r_vec(11)+50, N_mervec(11)-0.0, num2str(c_bodu_vec(11)),'Color','k')
text(r_vec(12)+50, N_mervec(12)+0.0, num2str(c_bodu_vec(12)),'Color','k')
text(r_vec(13)+50, N_mervec(13)-0.0, num2str(c_bodu_vec(13)),'Color','k')
text(r_vec(14)+50, N_mervec(14)-0.0, num2str(c_bodu_vec(14)),'Color','k')
text(r_vec(15)+50, N_mervec(15)+0.0, num2str(c_bodu_vec(15)),'Color','k')
text(r_vec(16)+50, N_mervec(16)+0.0, num2str(c_bodu_vec(16)),'Color','k')


% axis([-300, 15500]);
ylabel('Odlehlost [m]');
xlabel('Vzdalenost od zacatku profilu [m]');
title('Prubeh odlehlosti geoidu od elipsoidu GRS80 v profilu Hanusovice - Kladske sedlo');
hold off
