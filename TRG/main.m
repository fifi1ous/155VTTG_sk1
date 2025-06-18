clc; clear; format long G

%% Načtení a zpracování XML souborů s daty
% Cesta ke složce se soubory
folder = 'xml_soubory/';
files = dir(fullfile(folder, '*.xml'));

% Kontrolní proměnná pro uložení všech výstupů
data = struct();

for k = 1:length(files)
    filepath = fullfile(folder, files(k).name);
    fprintf('Zpracovávám: %s\n', files(k).name);
    
    try
        % Zavolání funkce
        d = parse_trgsit_xml(filepath);
        
        % Extrakce názvu podle stanoviska
        if isfield(d, 'stanovisko')
            stan = strtrim(d.stanovisko); % např. '1001'
            varname = ['data_' stan];        % např. 'data_1001'

            % Dynamické uložení do workspace proměnné
            data.(varname) = d;

            % uložit jako MAT soubor:
            % save(fullfile('data', [varname '.mat']), 'd');

        else
            warning('Soubor %s neobsahuje stanovisko.', files(k).name);
        end
    catch ME
        warning('Chyba při zpracování souboru %s:\n%s', files(k).name, ME.message);
    end
end
disp('Soubory načteny a zpracovány');

%% Centrace směrů
%% Převod směrů do roviny Křovákova zobrazení
ss = load("pribl_sour_jtsk.txt");
[S,U,ro1,eps] = jtsk2kar(ss(1),ss(1));
    

r = find(ss(:,1)==1002);
%%