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
% Each obsCellArray{i} is: {from, measurements}
% measurements is either an N×K cell (each row: {'angle', ...} or {'azimuth', ...})
% or an N×1 cell where each entry is a 1×K cell row. Both are handled.

for i = 1:numel(obsCellArray)
    obsData = obsCellArray{i};
    from = obsData{1};
    measurements = obsData{2};

    % Ensure measurements is a 2D cell we can index by rows
    % (If someone passed a column cell of cell-rows, unwrap on access below)
    obs = doc.createElement('obs');
    obs.setAttribute('from', num2str(from));

    for j = 1:size(measurements,1)
        mj = measurements(j,:);
        if numel(mj) == 1 && iscell(mj{1})
            m = mj{1};   % unwrap 1×K cell row
        else
            m = mj;      % already a row
        end
    
        mtype = char(m{1});
    
        % if m is itself a cell row, just handle once
        if size(m,1) == 1
            rows = {m};
        else
            rows = m;   % multiple rows
        end
    
        for k = 1:size(rows,1)
            mk = rows(k,:);   % one measurement row
            el = doc.createElement(mtype);

            if size(mk,2) == 1
                mk = mk{1};
            end
    
            switch mtype
                case 'angle'
                    el.setAttribute('bs',  num2str(mk{2}));
                    el.setAttribute('fs',  num2str(mk{3}));
                    el.setAttribute('val', sprintf('%.4f', mk{4}));
                    if numel(mk) >= 5 && ~isempty(mk{5})
                        el.setAttribute('stdev', sprintf('%.4f', mk{5}));
                    end
    
                case 'azimuth'
                    el.setAttribute('to',  num2str(mk{2}));
                    el.setAttribute('val', sprintf('%.4f', mk{3}));
                    if numel(mk) >= 4 && ~isempty(mk{4})
                        el.setAttribute('stdev', sprintf('%.4f', mk{4}));
                    end
    
                otherwise
                    el.setAttribute('to',  num2str(mk{2}));
                    el.setAttribute('val', sprintf('%.4f', mk{3}));
                    if numel(mk) >= 4 && ~isempty(mk{4})
                        el.setAttribute('stdev', sprintf('%.4f', mk{4}));
                    end
            end
    
            obs.appendChild(el);
        end
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
