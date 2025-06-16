function D_corr = OpravaZRefrakce(D, k)
% OPRAVA_REFRAKCE – Opraví délky D o refrakci.
% Vstupy:
%   D – vektor měřených délek (v metrech)
%   k – refrakční koeficient (volitelný, default 0.13)
%
% Výstup:
%   D_corr – opravený vektor délek

    if nargin < 2
        k = 0.13;  % výchozí hodnota
    end

    R = 6378000;              % poloměr Země v metrech
    r = R / k;                % zakřivení atmosféry

    D_corr = 2 * r .* sin(D ./ (2 * r));
end
