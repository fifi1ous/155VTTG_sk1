function data = parse_trgsit_xml(xmlFile)
% PARSE_TRGSIT_XML Načte a parsuje XML na matlab structure

    doc = xmlread(xmlFile);
    root = doc.getDocumentElement;

    % Základní metadata
    data.datum = char(root.getElementsByTagName('datum').item(0).getTextContent);
    data.skupina = char(root.getElementsByTagName('skupina').item(0).getTextContent);
    data.stanovisko = char(root.getElementsByTagName('stanovisko').item(0).getTextContent);
    data.pristroj = char(root.getElementsByTagName('pristroj').item(0).getTextContent);

    % Měřičská četa
    cetaNodes = root.getElementsByTagName('mericka-ceta');
    if cetaNodes.getLength > 0
        ceta = cetaNodes.item(0);
        merici = ceta.getElementsByTagName('meric');
        for i = 0:merici.getLength - 1
            data.mericka_ceta(i+1).jmeno = strtrim(char(merici.item(i).getTextContent));
        end
    else
        data.mericka_ceta = struct([]);
    end

    % Centracni-osnova ---
    coNodes = root.getElementsByTagName('centracni-osnova');
    if coNodes.getLength > 0
        co = coNodes.item(0);
        % načíst jednotlivé 'cil'
        cils = co.getElementsByTagName('cil');
        for i = 0:cils.getLength-1
            el = cils.item(i);
            data.centracni_osnova.cil(i+1).id = char(el.getAttribute('id'));
            data.centracni_osnova.cil(i+1).smer = str2double(el.getAttribute('smer'));
        end
        % načíst 'ex-cil'
        exCils = co.getElementsByTagName('ex-cil');
        for i = 0:exCils.getLength-1
            el = exCils.item(i);
            data.centracni_osnova.ex_cil(i+1).smer = str2double(el.getAttribute('smer'));
            data.centracni_osnova.ex_cil(i+1).delka = str2double(el.getAttribute('delka'));
        end
        % načíst 'centr'
        centrs = co.getElementsByTagName('centr');
        for i = 0:centrs.getLength-1
            el = centrs.item(i);
            data.centracni_osnova.centr(i+1).smer = str2double(el.getAttribute('smer'));
            data.centracni_osnova.centr(i+1).delka = str2double(el.getAttribute('delka'));
        end
    else
        data.centracni_osnova = struct('cil',[], 'ex_cil',[], 'centr',[]);
    end

    % Úhly
    uhly = root.getElementsByTagName('uhel');
    for i = 0:uhly.getLength-1
        el = uhly.item(i);
        data.uhel(i+1).id_leva = char(el.getAttribute('id-leva'));
        data.uhel(i+1).id_prava = char(el.getAttribute('id-prava'));
        data.uhel(i+1).pocet_lj = str2double(el.getAttribute('pocet-lj'));
        data.uhel(i+1).hodnota = str2double(el.getTextContent);
    end

    % Azimuty
    azimuty = root.getElementsByTagName('azimut');
    for i = 0:azimuty.getLength-1
        el = azimuty.item(i);
        if el.hasAttribute('id')
            data.azimut(i+1).id = char(el.getAttribute('id'));
            data.azimut(i+1).uhel = str2double(el.getAttribute('uhel'));
            data.azimut(i+1).cas_utc = char(el.getAttribute('cas-utc'));
        end
    end

    % Délky
    delky = root.getElementsByTagName('delka');
    for i = 0:delky.getLength-1
        el = delky.item(i);
        d.id2 = char(el.getAttribute('id2'));
        d.h1 = str2double(el.getAttribute('h1'));
        d.h2 = str2double(el.getAttribute('h2'));
        d.t1 = str2double(el.getAttribute('t1'));
        d.t2 = str2double(el.getAttribute('t2'));
        d.p1 = str2double(el.getAttribute('p1'));
        d.p2 = str2double(el.getAttribute('p2'));
        d.vlhko1 = str2double(el.getAttribute('vlhko1'));
        d.vlhko2 = str2double(el.getAttribute('vlhko2'));
        d.delka = str2double(el.getTextContent);
        data.delky(i+1) = d;
    end

    % Gyro (pokud je stanovisko 1001)
    if strcmp(data.stanovisko, '1001')
        gyro = root.getElementsByTagName('gyro-observace');
        if gyro.getLength > 0
            g = gyro.item(0);
            data.gyro.id = char(g.getAttribute('id'));
            data.gyro.datum = char(g.getElementsByTagName('datum').item(0).getTextContent);
            obsList = g.getElementsByTagName('observace');
            for i = 0:obsList.getLength-1
                obs = obsList.item(i);
                o.meric = char(obs.getElementsByTagName('meric').item(0).getTextContent);
                o.azimut = str2double(obs.getElementsByTagName('azimut').item(0).getTextContent);
                o.azimut_centr = str2double(obs.getElementsByTagName('azimut-centr').item(0).getTextContent);
                o.delka_centr = str2double(obs.getElementsByTagName('delka-centr').item(0).getTextContent);
                data.gyro.observace(i+1) = o;
            end
        end
    end
end
