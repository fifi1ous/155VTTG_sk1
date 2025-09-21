function [d_vodorovna] = VzdSouradnice(id_stroje, CB, hT_s, hT_c, S0, dmer)
% Vypočítá šikmou a vodorovnou délku mezi stanicí a cílem
% id_stroje – vektor bodů stanovišť přístroje
% CB        – vektor bodů cílů
% hT_s      – vektor výšek přístroje (pro každé měření)
% hT_c      – vektor výšek cíle (pro každé měření)
% S0        – matice [bod_id, X, Y, Z]
% dmer      - měřená délka

    if ~isequal(length(id_stroje), length(CB), length(hT_s), length(hT_c))
        error('Všechny vstupní vektory musí mít stejnou délku.');
    end

    n = length(CB);
    d_vodorovna = zeros(n, 1);
    % m_JTSK = zeros(n, 1);

    for q = 1:n
        id_s = id_stroje(q);
        id_c = CB(q);

        idx_s = find(S0(:,1) == id_s, 1);
        idx_c = find(S0(:,1) == id_c, 1);

        if isempty(idx_s) || isempty(idx_c)
            error('Bod %d nebo %d nebyl nalezen v souřadnicích.', id_s, id_c);
        end

        % Načti souřadnice a uprav výšku
        P_s = S0(idx_s, 2:4); P_s(3) = P_s(3) + hT_s(q);
        P_c = S0(idx_c, 2:4); P_c(3) = P_c(3) + hT_c(q);

        delka_red = mat_red(dmer(q), P_s(3), P_c(3));
        m_JTSK_s = red_JTSK(P_s(1), P_s(2));
        m_JTSK_c = red_JTSK(P_c(1), P_c(2));
        m_prum = (m_JTSK_s+m_JTSK_c)/2;

        m = 1/6*(m_JTSK_s + 4*m_prum + m_JTSK_c);

        d_vodorovna(q) = delka_red*m;
    end

    function delka_red = mat_red(delka_merena, H_stan, H_cile)
    % vypocte matematickou redukci do nuloveho horizontu
    % IN:   delka_merena    merena (fyzikalne redukovana) delka [m]
    %       H_stan          nadmorska vyska horizontu stroje    [m]
    %       H_cile          nadmorska vyska cile                [m]
    % OUT: delka_red        redukovana delka                    [m]
    
    % polomer nahradni koule
    R = 6381000;    % [m]
    
    h = H_cile - H_stan;
    numerator = delka_merena.^2 - h.^2;
    for i = 1:length(delka_merena)
        if delka_merena(i) == 0
            numerator(i) = 0;
        end
    end
    denominator = ( 1 + ( H_stan + H_cile) / R );
    delka_red = sqrt( numerator./denominator );
    end
    
    function m_JTSK = red_JTSK(X, Y)
    % vypocita redukci do JTSK 
    % IN:   [X, Y]          [m]
    % OUT:  m_JTSK          [-]
    R0 = 1298039; % [m]
    R = sqrt(X.^2 + Y.^2);
    delta_R = R - R0;
    m_JTSK = 0.9999 + 10^(-14) .* delta_R^2 .* ...
                ( 1.22822 - delta_R*10^(-7) .* ...
                  ( 3.154 - delta_R*10^(-6) .* ...
                  ( 1.848 - delta_R*10^(-6) .* 1.15 ) ) );
    end
end