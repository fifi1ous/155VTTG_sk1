function D = FyzikalniRedukce(D_mer, p, t, e, typ_pristroje)
% FYZIKALNI_REDUKCE Provádí fyzikální redukci vektorů měřených délek D_mer.
% Vstupy:
%   D_mer        – vektor měřených délek v metrech
%   p            – vektor atmosférických tlaků (mmHg pro Leica, hPa pro Topcon)
%   t            – vektor teplot ve °C
%   e            – vektor relativních vlhkostí vzduchu v %
%   typ_pristroje – 'Leica' nebo 'Topcon'
%
% Výstup:
%   D – vektor redukovaných délek v metrech

    % Kontrola vstupních délek
    if ~isequal(length(D_mer), length(p), length(t), length(e))
        error('Všechny vstupní vektory musí mít stejnou délku.');
    end

    % Inicializace výstupního vektoru
    D = zeros(size(D_mer));

    switch lower(typ_pristroje)
        case 'leica'
            alpha = 1 / 276.16;
            delta_D = 280.2096 ...
                      - 295.8193 .* (p ./ 760) ./ (1 + t .* alpha) ...
                      - 0.055 .* e ./ (1 + t .* alpha);
        case 'topcon'
            p = p * 1.33322368;
            delta_D = 279.85 - (79.585 .* p) ./ (273.15 + t);
        otherwise
            error('Neznámý typ přístroje. Zadejte "Leica" nebo "Topcon".');
    end

    % Výpočet korigovaných vzdáleností
    D = D_mer .* (1 + delta_D * 1e-6);
end
