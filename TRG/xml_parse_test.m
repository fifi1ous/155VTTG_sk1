clc; close all; clear variables; format longg;
% 
% 
% data = parse_trgsit_xml('xml_soubory/den1_13_1002_1.xml')
clc; close all; clear variables; format longg;

% Cesta ke složce se soubory
folder = 'xml_soubory/';
files = dir(fullfile(folder, '*.xml'));

% Kontrolní proměnná pro uložení všech výstupů
vystupy = struct();

for k = 1:length(files)
    filepath = fullfile(folder, files(k).name);
    fprintf('Zpracovávám: %s\n', files(k).name);
    
    try
        % Zavolání funkce
        data = parse_trgsit_xml(filepath);
        
        % Extrakce názvu podle stanoviska
        if isfield(data, 'stanovisko')
            stan = strtrim(data.stanovisko); % např. '1001'
            varname = ['data_' stan];        % např. 'data_1001'

            % Dynamické uložení do workspace proměnné
            vystupy.(varname) = data;

            % uložit jako MAT soubor:
            % save(fullfile('vystupy', [varname '.mat']), 'data');

        else
            warning('Soubor %s neobsahuje stanovisko.', files(k).name);
        end
    catch ME
        warning('Chyba při zpracování souboru %s:\n%s', files(k).name, ME.message);
    end
end
disp('Hotovo');
