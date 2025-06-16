 xml = readstruct("trg_format_dat.xml");

 % Pole s excentrickými stanovisky
 stanoviska = xml.exc_stanovisko_observace;

 % Procházíme každé exc. stanovisko
 for i = 1:length(stanoviska)

     fprintf('\nZpracovávám stanovisko %d:\n', i);

     % Nalezení směrových a délkových údajů
     osnova = stanoviska(i).centracni_osnova;
     cile = osnova.cil;

     % Extrahujeme směry podle ID cílů
     smer_map = containers.Map;
     for j = 1:length(cile)
         smer_map(string(cile(j).id)) = cile(j).Attributes.smer;
     end

     % Excentr a centr
     smer_ex = str2double(osnova.ex_cil.Attributes.smer);
     delka_ex = str2double(osnova.ex_cil.Attributes.delka);

     smer_centr = str2double(osnova.centr.Attributes.smer);
     delka_centr = str2double(osnova.centr.Attributes.delka);

     uhly = stanoviska(i).uhel;

     if ~iscell(uhly)
         uhly = {uhly}; % Zajistíme pole i pro 1 úhel
     end

     for j = 1:length(uhly)
         uhel_info = uhly{j};

         idL = string(uhel_info.Attributes.id_leva);
         idP = string(uhel_info.Attributes.id_prava);
         uhel_meren = str2double(uhel_info.Text);

         fprintf('  Úhel %s - %s: %.4f gon\n', idL, idP, uhel_meren);

         % Směry z XML (na S1)
         psi_c1_s1 = str2double(smer_map(idL));
         psi_c2_s1 = str2double(smer_map(idP));

         % Dummy hodnoty pro směry z S2 (můžeme později načítat jinak)
         psi_t1 = 100.0; psi_t2 = 300.0; % směry na trigasy
         e_s1t1 = 1.5; e_s1c1 = delka_centr;
         e_s2t2 = 1.5; e_s2c1 = delka_ex;

         % Volání výpočtu centrovaného úhlu
         uhel_centrovany = ZcentrujUhel(uhel_meren, ...
             psi_c1_s1, psi_t1, e_s1t1, e_s1c1, ...
             psi_c1_s1, psi_t2, e_s2t2, e_s2c1, ...
             psi_c2_s1, psi_t1, e_s1t1, delka_centr, ...
             psi_c2_s1, psi_t2, e_s2t2, delka_ex, ...
             12.345);  % délka mezi trigasy – ideálně z XML

         fprintf('    => Zcentrovaný úhel: %.4f gon\n', uhel_centrovany);
     end
 end
