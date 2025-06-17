function generate_gama_xml(outputFile, descriptionLines, sigma_apr, conf_pr, tol_abs, sigma_act_str, pointsCellArray, obsCellArray, angStdev, distStdev, azimStdev)

    doc = com.mathworks.xml.XMLUtils.createDocument('gama-xml');
    root = doc.getDocumentElement;
    root.setAttribute('version', '2.0');

    %% DOCTYPE

    %% Síť
    network = doc.createElement('network');
    network.setAttribute('axes-xy', 'sw');
    network.setAttribute('angles', 'right-handed');
    root.appendChild(network);

    %% Popis
    description = doc.createElement('description');
    description.appendChild(doc.createTextNode(sprintf('%s\n%s', ...
        descriptionLines{1}, descriptionLines{2})));
    network.appendChild(description);

    %% Parametry
    parameters = doc.createElement('parameters');
    parameters.setAttribute('sigma-apr', sprintf('%.3f', sigma_apr));
    parameters.setAttribute('conf-pr', sprintf('%.3f', conf_pr));
    parameters.setAttribute('tol-abs', sprintf('%.3f', tol_abs));
    parameters.setAttribute('sigma-act', sigma_act_str);
    network.appendChild(parameters);

    %% Sm. odchylky
    po = doc.createElement('points-observations');
    po.setAttribute('angle-stdev', angStdev);
    po.setAttribute('distance-stdev', distStdev);
    po.setAttribute('azimuth-stdev', azimStdev);
    network.appendChild(po);

    %% Body
for i = 1:size(pointsCellArray, 1)
    row = pointsCellArray{i};         % Vyber řádek jako buňku
    id = row{1};
    type = row{2};
    
    point = doc.createElement('point');
    point.setAttribute('id', num2str(id));
    
    if strcmp(type, 'fix')
        x = row{end-1};
        y = row{end};
        point.setAttribute('x', sprintf('%.2f', x));
        point.setAttribute('y', sprintf('%.2f', y));
        point.setAttribute('fix', 'XY');
    elseif strcmp(type, 'adj')
        xyType = row{3};
        if length(row)>3
            x = row{4};
            y = row{5};
            point.setAttribute('x', sprintf('%.2f', x));
            point.setAttribute('y', sprintf('%.2f', y));
        end
        point.setAttribute('adj', xyType);
    end

    po.appendChild(point);
end


    %% Observace
    % Každá buňka: {from, measurements}, kde:
    % measurements = {typ, to_id, hodnota; ...}
    for i = 1:length(obsCellArray)
        obsData = obsCellArray{i};
        from = obsData{1};
        measurements = obsData{2};

        obs = doc.createElement('obs');
        obs.setAttribute('from', num2str(from));

        for j = 1:length(measurements)
            m = measurements{j};  % m = {'angle', bs, fs, val, [optional stdev]}
            mtype = strtrim(m{1});
            el = doc.createElement(mtype);
        
            switch mtype
                case 'angle'
                    el.setAttribute('bs', num2str(m{2}));
                    el.setAttribute('fs', num2str(m{3}));
                    el.setAttribute('val', sprintf('%.4f', m{4}));
                    if numel(m) >= 5
                        el.setAttribute('stdev', sprintf('%.4f', m{5}));
                    end
                otherwise
                    el.setAttribute('to', sprintf(' %d ', m{2}));
                    el.setAttribute('val', sprintf('%.4f', m{3}));
                    if numel(m) >= 4
                        el.setAttribute('stdev', sprintf('%.4f', m{4}));
                    end
            end
        
            obs.appendChild(el);
        end

        po.appendChild(obs);
    end

    %% Uložení bez DOCTYPE
    tmpFile = [tempname, '.xml'];
    xmlwrite(tmpFile, doc);

    %% Přidání hlavičky a DOCTYPE
    lines = fileread(tmpFile);
    fid = fopen(outputFile, 'w');
    fprintf(fid, '<?xml version="1.0" ?>\n');
    fprintf(fid, '<!DOCTYPE gama-local SYSTEM "gama-local.dtd">\n');
    fwrite(fid, lines);
    fclose(fid);
    delete(tmpFile);
    
    fprintf('Soubor uložen: %s\n', outputFile);
end
