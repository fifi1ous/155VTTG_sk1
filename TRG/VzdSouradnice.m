function [d_sikma, d_vodorovna] = VzdSouradnice(id_stroje, CB, hT_s, hT_c, S0)
% Vypočítá šikmou a vodorovnou délku mezi stanicí a cílem
% id_stroje – vektor bodů stanovišť přístroje
% CB        – vektor bodů cílů
% hT_s      – vektor výšek přístroje (pro každé měření)
% hT_c      – vektor výšek cíle (pro každé měření)
% S0        – matice [bod_id, X, Y, Z]

    if ~isequal(length(id_stroje), length(CB), length(hT_s), length(hT_c))
        error('Všechny vstupní vektory musí mít stejnou délku.');
    end

    n = length(CB);
    d_sikma = zeros(n, 1);
    d_vodorovna = zeros(n, 1);

    for i = 1:n
        id_s = id_stroje(i);
        id_c = CB(i);

        idx_s = find(S0(:,1) == id_s, 1);
        idx_c = find(S0(:,1) == id_c, 1);

        if isempty(idx_s) || isempty(idx_c)
            error('Bod %d nebo %d nebyl nalezen v souřadnicích.', id_s, id_c);
        end

        % Načti souřadnice a uprav výšku
        P_s = S0(idx_s, 2:4); P_s(3) = P_s(3) + hT_s(i);
        P_c = S0(idx_c, 2:4); P_c(3) = P_c(3) + hT_c(i);

        delta = P_c - P_s;

        d_sikma(i) = norm(delta);
        d_vodorovna(i) = norm(delta(1:2));
    end
end
