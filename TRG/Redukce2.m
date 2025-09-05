function [delky,delky2] = Redukce2(data)
    pristroj = data.pristroj;
    
    % konstanta hranolu
    if pristroj=="topcon"
        konst_hr = 0.028;
    elseif pristroj=="leica"
        konst_hr = -0.002;
    else
        error('Neznámý typ přístroje. Zadejte "Leica" nebo "Topcon".');
    end

    % Create logical index for rows where delka ~= -1
    idx = [data.delky.delka] ~= -1;
    
    % Keep only those rows
    data.delky = data.delky(idx);

    
    % měřené dílky
    d = [data.delky.delka];

    % odkud se dané délky měřily
    stanovisko = str2num(data.stanovisko(1:4));
  
    % kam se dané délky měřily
    id2 = {data.delky.id2};           % všechna id2 z pole struktur
    CB_cile = str2double(string(id2));

    CB_stroj = repmat(stanovisko, 1, length(CB_cile));
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
            v_s(i) = Vlhkost(t_s(i), t_ws(i), p_s(i));
        end
        if v_c(i) == -1
            v_c(i) = Vlhkost(t_c(i), t_wc(i), p_s(i));
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
    delky = [CB_stroj',CB_cile',dJTSK'];
    % Extract columns
    col1 = delky(:,1);
    col2 = delky(:,2);
    col3 = delky(:,3);
    
    % Group by col2
    [uniqueVals, ~, idx] = unique(col2);
    meanVals = accumarray(idx, col3, [], @mean);
    
    % Since col1 is always 1004 in your example, we can take the first one
    col1_val = col1(1);
    
    % Build final matrix
    delky2 = [repmat(col1_val, numel(uniqueVals), 1), uniqueVals, meanVals];
end