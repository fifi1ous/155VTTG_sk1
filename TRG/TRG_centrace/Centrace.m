clc; clear;

stanoviska = [1001, 1002, 1003, 1004];
dataMap = containers.Map('KeyType', 'double', 'ValueType', 'any');

for i = 1:length(stanoviska)
    s = stanoviska(i);
    filename = sprintf('den1_1_%d_1.xml', s);
    dataMap(s) = parse_trgsit_xml(filename);
end


%for i = 1:length(stanoviska)
%
%      for j = 1:length(data.uhly)
%         uhel = data.uhly(j);
%         idL = str2double(uhel.id_leva);
%         idP = str2double(uhel.id_prava);
%         hodnotaU = uhel.hodnota;


for stanovisko=1:length(stanoviska)

   dataS = dataMap(stanovisko);

   % Vyberme jeden úhel - např. mezi 1001 a 1002
   % Hledáme ho v dataS.uhel
   for i = 1:length(dataS.uhel)
       lev = str2double(dataS.uhel(i).id_leva);
       prav = str2double(dataS.uhel(i).id_prava);
       uhel_meren = dataS.uhel(i).hodnota;

%       if ( (lev == 1001 && prav == 1002) || (lev == 1002 && prav == 1001) )
%           uhelHodnota = dataS.uhel(i).hodnota;
%           break;
%       end
   end

   % Najdi centrační prvky na stanovisku
   centracniS = [];
   for i = 1:length(dataS.exc_stanovisko_observace)
       osnovaS = dataS.exc_stanovisko_observace(i).centracni_osnova;

       if ~isempty(osnovaS)
           centracniS = osnovaS;
           break;
       end
   end

%   psi_s1c3 = centracniS.cil(prav).smer;

   psi_s1c2 = centracniS.cil(lev).smer;
   psi_s1c1 = centracniS.ex_cil.smer;
   psi_s1t1 = centracniS.centr.smer;
   e_s1t1 = centracniS.centr.delka;
   e_s1c1 = centracniS.ex_cil.delka;

%   % Najdi směr z excentrického stanoviska na cíl 1001 a 1002
%   % + najdi směr na středový bod (centr) a vzdálenosti
%   smer1 = NaN; smer2 = NaN;
%   smer_centr = NaN; delka_centr = NaN;
%
%   for j = 1:length(centracni)
%       if isfield(centracni(j), 'cil')
%           for k = 1:length(centracni(j).cil)
%               c = centracni(j).cil(k);
%               if str2double(c.id) == 1001
%                   smer1 = str2double(c.smer);
%               elseif str2double(c.id) == 1002
%                   smer2 = str2double(c.smer);
%               end
%           end
%       end
%
%       if isfield(centracni(j), 'centr')
%           smer_centr = str2double(centracni(j).centr.smer);
%           delka_centr = str2double(centracni(j).centr.delka);
%       end
%   end

   % Stejně najdi centrační údaje pro cíle
   dataL = dataMap(lev);
   dataP = dataMap(prav);

   % Najdi centrační prvky na levém cíli
   centracniL = [];
   for i = 1:length(dataL.exc_stanovisko_observace)
       osnovaL = dataL.exc_stanovisko_observace(i).centracni_osnova;

       if ~isempty(osnovaL)
           centracniL = osnovaL;
           break;
       end
   end


   psi_s2c1 = centracniL.cil(stanovisko).smer;
   psi_s2c2 = centracniL.ex_cil.smer;
   psi_s2t2 = centracniL.centr.smer;
   e_s2t2 = centracniL.centr.delka;
   e_s2c2 = centracniL.ex_cil.delka;


      % Najdi centrační prvky na levém cíli
   centracniP = [];
   for i = 1:length(dataP.exc_stanovisko_observace)
       osnovaL = dataP.exc_stanovisko_observace(i).centracni_osnova;

       if ~isempty(osnovaP)
           centracniP = osnovaP;
           break;
       end
   end

   psi_s1c3 = centracniS.cil(prav).smer;

   psi_s3c1 = centracniP.cil(stanovisko).smer;
   psi_s3c3 = centracniP.ex_cil.smer;
   psi_s3t3 = centracniP.centr.smer;
   e_s3t3 = centracniP.centr.delka;
   e_s3c3 = centracniP.ex_cil.delka;


   % JE POTŘEBA JEŠTĚ MÍT DÉLKY MEZI CENTRY ZE SOUŘADNIC
   uhel_centrovany = ZcentrujUhel(uhel_meren, ...
        psi_s1c2, psi_s1c1, psi_s1t1, e_s1t1, e_s1c1, ...
        psi_s2c1, psi_s2c2, psi_s2t2, e_s2t2, e_s2c2, ...
        psi_s1c3, psi_s3c1, psi_s3c3, psi_s3t3, e_s3t3, e_s3c3, ...
        s_t1t2, s_t1t3)

   % Zatím nikam neukládá hodnoty

end
