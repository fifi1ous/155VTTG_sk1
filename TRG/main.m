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
%% Redukce délek

%% Centrace směrů

%% Převod směrů do roviny Křovákova zobrazení
ss = load("pribl_sour_jtsk.txt");
[S,U,ro1,eps] = jtsk2kar(ss(1),ss(1));
    

r = find(ss(:,1)==1002);

%% Výpočet astronomických azimutů

%% Kompletace dat

%% Vytvoření XML souboru pro vyrovnání v Gamě
% vstupni parametry - upravit dle potreby
% popis
description = {'Volná síť, opěrné 1001,1002', '155VTTG - sk1,3 2025'};
% apriorní směrodatná odchylka
sigma_apr = 1.0;
% interval spolehlivosti
conf_pr = 0.95;
% tolerance
tol_abs = 1000.0;
% sm. o. vyuzita pro vypocet vyslednych sm.o. (apriori/aposteriori)
sigma_act = 'apriori';
% sm. och. merenych velicin
    %bud obecne zde, nebo muze byt upresneno u konkretniho mereni jako
    %volitelny dalsi parametr
angStdev = "10"; % v gradovych vterinach
distStdev = "5 3 1"; % a + b*D^c, D je v km
azimStdev = "10"; % v gradovych vterinach

% Souřadnice bodů v S-JTSK
% points = {
%     {4001,'fix', 5000, 1000}; % bod je fixní
%     {4002,'adj','XY', 5000, 1000}; % bod je opěrný
%     {4003,'adj','xy', 5000, 1000}; % bod je vyrovnávaný
%     {4004,'adj','xy'}; % bod je vyrovnávaný a nemáme přibliž. souř
% };

points = {
    {1001,'adj','XY', 1055386.291, 565725.159};
    {1002,'adj','XY', 1058509.547, 560713.097};
    {1003,'adj','xy', 1055296.051, 560933.350}; 
    {1004,'adj','xy', 1053013.574, 559765.560}; 
    {1004,'adj','xy', 1055721.093, 562456.195};
};

% Měření: {typ, kam, hodnota}
obs1001 = {1001, {
    {'angle', 422, 402, 128.6548};
    {'distance', 4002, 538.84}
    {'azimuth', 4002, 122.8445};
}};
obs1002 = {1002, {
    {'angle',     4003,4001, 61.1804};
    {'distance',  4001, 538.87};
}};
obsArray = {obs1001, obs1002};

% generovani
generate_gama_xml('gama_xml.xml', description, sigma_apr, conf_pr, tol_abs, sigma_act, points, obsArray, angStdev, distStdev,azimStdev);

