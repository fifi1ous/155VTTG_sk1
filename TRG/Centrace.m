clc; clear; format long g;

stanoviska = ["1001", "1002", "1003a", "1003b", "1004"];
%dataMap = containers.Map('KeyType', 'double', 'ValueType', 'any');

centrovaneUhly = {};
centrovaneAzimuty = {};

% Seznam všech souborů odpovídajících vzoru
files = dir('den1_13_*_1.xml');

dataMap = containers.Map;

for i = 1:length(files)
    filename = files(i).name;

    % Extrahuj ID stanoviska ze jména souboru (např. 1003a, 1004, ...)
    tokens = regexp(filename, 'den1_13_([0-9a-zA-Z]+)_1\.xml', 'tokens');
    if ~isempty(tokens)
        stanoviskoID = tokens{1}{1};
        % Načti data
        dataMap(stanoviskoID) = parse_trgsit_xml(filename);
    else
        warning('Soubor %s neodpovídá očekávanému vzoru.', filename);
    end
end


for stan=1:length(stanoviska)

   stanovisko = stanoviska(stan);
   dataS = dataMap(stanovisko);

   % Vyberme jeden úhel - např. mezi 1001 a 1002
   % Hledáme ho v dataS.uhel
   for i = 1:length(dataS.uhel)
       % lev = str2double(dataS.uhel(i).id_leva);
       % prav = str2double(dataS.uhel(i).id_prava);
       lev = convertCharsToStrings(dataS.uhel(i).id_leva);
       prav = convertCharsToStrings(dataS.uhel(i).id_prava);
       uhel_meren = dataS.uhel(i).hodnota;

    centracniS = dataS.centracni_osnova;

   %   psi_s1c3 = centracniS.cil(prav).smer;

      idxL = find(arrayfun(@(c) c.id == lev, centracniS.cil));
      psi_s1c2 = centracniS.cil(idxL).smer;

      %psi_s1c2 = centracniS.cil(lev).smer;
      psi_s1c1 = centracniS.ex_cil.smer;
      psi_s1t1 = centracniS.centr.smer;
      e_s1t1 = centracniS.centr.delka;
      e_s1c1 = centracniS.ex_cil.delka;


      % Stejně najdi centrační údaje pro cíle
      if lev == "1003"
          dataL = dataMap("1003a");
      else
          dataL = dataMap(lev);
      end

      if prav == "1003"
          dataP = dataMap("1003a");
      else
          dataP = dataMap(prav);
      end


      centracniL = dataL.centracni_osnova;

      if stanovisko == "1003a" || stanovisko == "1003b"
          idxLS = find(arrayfun(@(c) c.id == "1003", centracniL.cil));
      else
          idxLS = find(arrayfun(@(c) c.id == stanovisko, centracniL.cil));
      end

      psi_s2c1 = centracniL.cil(idxLS).smer;
      psi_s2c2 = centracniL.ex_cil.smer;
      psi_s2t2 = centracniL.centr.smer;
      e_s2t2 = centracniL.centr.delka;
      e_s2c2 = centracniL.ex_cil.delka;

      centracniP = dataP.centracni_osnova;

      if stanovisko == "1003a" || stanovisko == "1003b"
          idxPS = find(arrayfun(@(c) c.id == "1003", centracniP.cil));
      else
          idxPS = find(arrayfun(@(c) c.id == stanovisko, centracniP.cil));
      end

      psi_s3c1 = centracniP.cil(idxPS).smer;

      psi_s3c3 = centracniP.ex_cil.smer;
      psi_s3t3 = centracniP.centr.smer;
      e_s3t3 = centracniP.centr.delka;
      e_s3c3 = centracniP.ex_cil.delka;

      idxP = find(arrayfun(@(c) c.id == prav, centracniS.cil));
      psi_s1c3 = centracniS.cil(idxP).smer;

      % Délky ze souřadnic

      priblizky = load("pribl_sour_jtsk.txt");
      if stanovisko == "1003a" || stanovisko == "1003b"
          S = priblizky(find(priblizky(:,1)==str2double("1003")),:);
      else
          S = priblizky(find(priblizky(:,1)==str2double(stanovisko)),:);
      end
      
      L = priblizky(find(priblizky(:,1)==str2double(lev)),:);
      P = priblizky(find(priblizky(:,1)==str2double(prav)),:);

      s_t1t2 = sqrt( ( S(2) - L(2) )^2 + ( S(3) - L(3) )^2 );
      s_t1t3 = sqrt( ( S(2) - P(2) )^2 + ( S(3) - P(3) )^2 );

      % JE POTŘEBA JEŠTĚ MÍT DÉLKY MEZI CENTRY ZE SOUŘADNIC
      uhel_centrovany = ZcentrujUhel(uhel_meren, ...
           psi_s1c2, psi_s1c1, psi_s1t1, e_s1t1, e_s1c1, ...
           psi_s2c1, psi_s2c2, psi_s2t2, e_s2t2, e_s2c2, ...
           psi_s1c3, psi_s3c1, psi_s3c3, psi_s3t3, e_s3t3, e_s3c3, ...
           s_t1t2, s_t1t3);

      % Zatím nikam neukládá hodnoty

      centrovaneUhly{end+1,1} = stanoviska(stan);  % číselné stanovisko
      centrovaneUhly{end,2} = lev;
      centrovaneUhly{end,3} = prav;
      centrovaneUhly{end,4} = uhel_centrovany;

   end

   % % Najdeme ještě měřený astronomicky určený azimut a také ho zcentrujeme (jako směr)
   % 
   % for i = 1:length(dataS.azimut)
   % 
   %    id_az = convertCharsToStrings(dataS.azimut(i).id);
   %    azimut_meren = dataS.azimut(i).uhel;
   % 
   %    % Najdi centrační prvky na cíli
   %    if id_az == "1003"
   %        dataA = dataMap("1003a");
   %    else
   %        dataA = dataMap(id_az);
   %    end
   % 
   %    centracniA = dataA.centracni_osnova;  
   % 
   %    idxA = find(arrayfun(@(c) c.id == id_az, centracniS.cil));
   %    psi_s1cA = centracniS.cil(idxA).smer;
   % 
   %    psi_s1c1 = centracniS.ex_cil.smer;
   %    psi_s1t1 = centracniS.centr.smer;
   %    e_s1t1 = centracniS.centr.delka;
   %    e_s1c1 = centracniS.ex_cil.delka;
   % 
   %    if stanovisko == "1003a" || stanovisko == "1003b"
   %        idxAS = find(arrayfun(@(c) c.id == "1003", centracniA.cil));
   %    else
   %        idxAS = find(arrayfun(@(c) c.id == stanovisko, centracniA.cil));
   %    end
   % 
   %    psi_sAc1 = centracniA.cil(idxAS).smer;
   % 
   %    psi_sAcA = centracniA.ex_cil.smer;
   %    psi_sAtA = centracniA.centr.smer;
   %    e_sAtA = centracniA.centr.delka;
   %    e_sAcA = centracniA.ex_cil.delka;
   % 
   %    % Delka ze souradnic
   %    A = priblizky(find(priblizky(:,1)==str2double(id_az)),:);
   % 
   %    s_t1tA = sqrt( ( S(2) - A(2) )^2 + ( S(3) - A(3) )^2 );
   % 
   %    azimut_centrovany = ZcentrujSmer(azimut_meren, ...
   %         psi_s1cA, psi_s1c1, psi_s1t1, e_s1t1, e_s1c1, ...
   %         psi_sAcA, psi_sAc1, psi_sAtA, e_sAtA, e_sAcA, ...
   %         s_t1tA);
   % 
   % 
   %    centrovaneAzimuty{end+1,1} = stanoviska(stan);  % číselné stanovisko
   %    centrovaneAzimuty{end,2} = id_az;
   %    centrovaneAzimuty{end,3} = azimut_centrovany;


   % end

end

T = cell2table(centrovaneUhly, ...
    'VariableNames', {'Stanovisko', 'LevyBod', 'PravyBod', 'UhelCentrovany'});

% A = cell2table(centrovaneAzimuty, ...
%     'VariableNames', {'Stanovisko', 'Cil', 'AzimutCentrovany'});
