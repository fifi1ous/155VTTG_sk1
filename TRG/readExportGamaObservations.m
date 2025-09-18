function obsCell = readExportGamaObservations(xmlFile)
    % Reads a GAMA XML export and extracts observation data into a cell array.
    %
    % Input:
    %   xmlFile - path to export_gama.xml
    %
    % Output:
    %   obsCell - cell array with observations:
    %             {Type, From, To/Left, Right, Obs, Adj, StdDev}
    
    % Read XML
    xDoc = xmlread(xmlFile);
    
    % Get all observation nodes (angle, distance, azimuth)
    obsTypes = {'angle','distance','azimuth'};
    obsCell = {};
    
    for t = 1:numel(obsTypes)
        nodes = xDoc.getElementsByTagName(obsTypes{t});
        for i = 0:nodes.getLength-1
            node = nodes.item(i);
            
            % Extract common values
            from = char(node.getElementsByTagName('from').item(0).getTextContent);
            
            switch obsTypes{t}
                case 'angle'
                    left  = char(node.getElementsByTagName('left').item(0).getTextContent);
                    right = char(node.getElementsByTagName('right').item(0).getTextContent);
                    toVal = sprintf('%s-%s',left,right);
                otherwise
                    toVal = char(node.getElementsByTagName('to').item(0).getTextContent);
                    if isempty(toVal)
                        % for azimuth no <to> tag? → check again
                        toNode = node.getElementsByTagName('to');
                        if toNode.getLength > 0
                            toVal = char(toNode.item(0).getTextContent);
                        else
                            toVal = '';
                        end
                    end
            end
            
            obs  = str2double(char(node.getElementsByTagName('obs').item(0).getTextContent));
            adj  = str2double(char(node.getElementsByTagName('adj').item(0).getTextContent));
            stdev = str2double(char(node.getElementsByTagName('stdev').item(0).getTextContent));
            
            % Append to cell
            obsCell(end+1,:) = {obsTypes{t}, from, toVal, adj, obs, stdev}; %#ok<AGROW>
        end
    end
end
