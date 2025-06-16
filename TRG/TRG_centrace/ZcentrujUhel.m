function [uhel_centrovany] = ZcentrujUhel(uhel_meren, ...
    psi_c1_s1, psi_t1_c1, e_s1t1_c1, e_s1c1, ...
    psi_c1_s2, psi_t2_c1, e_s2t2_c1, e_s2c1, ...
    psi_c2_s1, psi_t1_c2, e_s1t1_c2, e_s1c2, ...
    psi_c2_s2, psi_t2_c2, e_s2t2_c2, e_s2c2, ...
    s_t1t2)

    % Výpočet centrovaného směru na C1
    delta_c1 = CentraciZmena( ...
        psi_c1_s1, psi_c1_s1, psi_t1_c1, e_s1t1_c1, e_s1c1, ...
        psi_c1_s2, psi_c1_s2, psi_t2_c1, e_s2t2_c1, e_s2c1, s_t1t2);

    % Výpočet centrovaného směru na C2
    delta_c2 = CentraciZmena( ...
        psi_c2_s1, psi_c2_s1, psi_t1_c2, e_s1t1_c2, e_s1c2, ...
        psi_c2_s2, psi_c2_s2, psi_t2_c2, e_s2t2_c2, e_s2c2, s_t1t2);

%    % Změřený rozdíl směrů (měřený úhel)
%    uhel_meren_diff = psi_c2_s1 - psi_c1_s1;
%    if uhel_meren_diff < 0
%        uhel_meren_diff = uhel_meren_diff + 400;
%    end
%
%    % Rozdíl centrovaných směrů
%    uhel_centrovany_diff = smer_c2 - smer_c1;
%    if uhel_centrovany_diff < 0
%        uhel_centrovany_diff = uhel_centrovany_diff + 400;
%    end
%
%    % Korekce = rozdíl centrovaný - měřený
%    korekce = uhel_centrovany_diff - uhel_meren_diff;
%
%    % Výsledek = měřený úhel + korekce
%    uhel_centrovany = uhel_meren + korekce;

   uhel_centrovany = uhel_meren + delta_c2 - delta_c1;

    % Normalizace do intervalu 0–400
    if uhel_centrovany < 0
        uhel_centrovany = uhel_centrovany + 400;
    elseif uhel_centrovany >= 400
        uhel_centrovany = uhel_centrovany - 400;
    end
end
