function [smer_centrovany] = ZcentrujSmer(smer_meren, ...
        psi_s1c2, psi_s1c1, psi_s1t1, e_s1t1, e_s1c1, ...
        psi_s2c2, psi_s2c1, psi_s2t2, e_s2t2, e_s2c2, ...
        s_t1t2)


    % Výpočet centrovaného směru na C1
    delta_c1 = CentraciZmena( ...
        psi_c1_s1, psi_c1_s1, psi_t1_c1, e_s1t1_c1, e_s1c1, ...
        psi_c1_s2, psi_c1_s2, psi_t2_c1, e_s2t2_c1, e_s2c1, ...
        s_t1t2);


   smer_centrovany = smer_meren + delta_c1;

    % Normalizace do intervalu 0–2Pi
    if smer_centrovany < 0
        smer_centrovany = smer_centrovany + 2*pi;
    elseif smer_centrovany >= 2*pi
        smer_centrovany = smer_centrovany - 2*pi;
    end
end
