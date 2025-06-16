clc; close all; clear variables; format longg;

data = parse_trgsit_xml("trg_format_dat.xml");
pristroj = data.pristroj;

% konstanta hranolu
if pristroj=="topcon"
    konst_hr = 0.028;
elseif pristroj=="leica"
    konst_hr = -0.002;
else
    error('Neznámý typ přístroje. Zadejte "Leica" nebo "Topcon".');
end

% měřené dílky
d = [data.delky.delka];
% odkud se dané délky měřily
stanovisko = data.stanovisko;
CB_stroj = repmat(stanovisko, 1, 6);
% kam se dané délky měřily
CB_cile = [data.delky.id2];
% oprava o konstantu hranolu
d = d+konst_hr;
% suchá teplota na stanovisku !!! My měli teploměr, který měřil vlhkost,
% pokud jste měřili vlhkou a suchou teplotu přidejte si ještě vlhkou
% teplotu a v_s vyplňte podle tabulky, nebo pomocí funkce Vlhkost!!! -
% viz.níže
t_s = [data.delky.t1];
% suchá teplota na cílech
t_c = [data.delky.t2];
% vlhká teplota na stanovisku
t_ws = [data.delky.tw1];
% vlhká teplota na stanovisku
t_wc = [data.delky.tw2];
% tlak na stanovisku v torrech
p_s = [data.delky.p1];
p_s(p_s < 0) = abs(p_s(p_s < 0)) * 0.750061683;
% tlak na cílech v torrech
p_c = [data.delky.p2];
p_c(p_c < 0) = abs(p_c(p_c < 0)) * 0.750061683;
% vlhkost na stanovisku - možno počítat!
v_s = [data.delky.vlhko1];
v_c = [data.delky.vlhko2];
for i = 1:length(v_s)
    if v_s(i) == -1
        v_s(i) = Vlhkost(t_s(i), t_s(i), p_s(i));
    end
    if v_c(i) == -1
        v_c(i) = Vlhkost(t_c(i), t_c(i), p_s(i));
    end
end
% průměrná teplota
t = (t_s+t_c)/2;
% průměrný tlak
p = (p_s+p_c)/2;
% průměrná vlhkost
v = (v_s+v_c)/2;
% Fyzikální redukce - zadat topcon nebo leica, funkce umí obojí
d_F = FyzikalniRedukce(d, p, t, v, pristroj);
% oprava z refrakce - podle Vyskyho má vycházet takhle malá
dmer = OpravaZRefrakce(d_F);
% výšky stroje
hT_s = [data.delky.h1];
% výšky hranolů
hT_c = [data.delky.h2];
% Přibližky - jsou X,Y,Z, ne BLH, jako píšou v zadání!
S0 = load("S0.txt");
% Výpočet vzdálenosti ze souřadnic
[d0XYZ, d0JTSK] = VzdSouradnice(CB_stroj, CB_cile, hT_s, hT_c, S0);
% Výsledné redukované délky
dJTSK = (dmer.*d0JTSK')./d0XYZ';
