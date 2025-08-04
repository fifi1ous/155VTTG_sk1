clc; clear; format long G
%% načtení přibližných souřadnic
ss = load("pribl_sour_jtsk.txt");

gon2rad = pi/200; 
%% Načtení a zpracování XML souborů s daty
% Cesta ke složce se soubory
folder = 'xml_soubory/';
files = dir(fullfile(folder, '*.xml'));

% Kontrolní proměnná pro uložení všech výstupů
data = struct();

% Proměnné pro zpětné volání jednotlivých dat
variables = [];
stanoviska = [];

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

            % uložení názvů proměných pro snadnější indexování
            stanoviska = [stanoviska,string(stan)];
            variables = [variables,string(varname)];

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

pocet_stanovisek = length(variables);
id_azimut = '';

stanoviska_IDs = zeros(1, pocet_stanovisek);
data_structs = cell(1, pocet_stanovisek);
for i = 1:pocet_stanovisek
    data_structs{i} = data.(variables(i));
    stanoviska_IDs(i) = str2double(data.(variables(i)).stanovisko(1:4));
end

opravy_smeru = [];
for i = 1:pocet_stanovisek
    pom_1 = data_structs{i};
    st = stanoviska_IDs(i);

    osnova_1 = pom_1.centracni_osnova.cil;
    cil_1 = pom_1.centracni_osnova.ex_cil;
    centr_1 = pom_1.centracni_osnova.centr;

    [Y_k1, X_k1] = findPoint(ss, st);

    ids = str2double({osnova_1.id});
    if isfield(pom_1, 'gyro')
        id_azimut = pom_1.gyro.id;
        gyro_mereni = pom_1.gyro.observace;
    end

    for j = 1:length(ids)
        idx_n = find(stanoviska_IDs == ids(j), 1);
        if isempty(idx_n), continue; end

        pom_2 = data_structs{idx_n};
        st2 = stanoviska_IDs(idx_n);

        [Y_k2, X_k2] = findPoint(ss, st2);
        delka_ss = hypot(Y_k2 - Y_k1, X_k2 - X_k1);

        osnova_2 = pom_2.centracni_osnova.cil;
        cil_2 = pom_2.centracni_osnova.ex_cil;
        centr_2 = pom_2.centracni_osnova.centr;

        idx1 = strcmp({osnova_1.id}, sprintf('%04d', st2));
        smer_1 = osnova_1(idx1).smer;

        idx2 = strcmp({osnova_2.id}, sprintf('%04d', st));
        smer_2 = osnova_2(idx2).smer;

        [~, oprava] = ZcentrujSmer(smer_1*gon2rad, ...
            smer_1*gon2rad, cil_1.smer*gon2rad, centr_1.smer*gon2rad, centr_1.delka, cil_1.delka, ...
            smer_2*gon2rad, cil_2.smer*gon2rad, centr_2.smer*gon2rad, centr_2.delka, cil_2.delka, ...
            delka_ss);
            % Měřený úhel při měření centrační osnovy, , úhel na excentrický cíl, úhel na centr, délka na centr, délka na exentrický cíl 
        oprava = oprava / gon2rad;
        opravy_smeru = [opravy_smeru; st, st2, oprava];
    end

    id_l = strcmp({pom_1.uhel.id_leva}, id_azimut);
    id_p = strcmp({pom_1.uhel.id_prava}, id_azimut);
    if any(id_l) || any(id_p)
        gyro_azimut = size(gyro_mereni,2);

        [Y_k2, X_k2] = findPoint(ss, str2num(id_azimut));
        delka_ss = hypot(Y_k2 - Y_k1, X_k2 - X_k1);

        idx1 = strcmp({pom_1.uhel.id_leva}, id_azimut);
        if any(idx1)
            smer = 0;
        else
            idx1 = strcmp({pom_1.uhel.id_prava}, id_azimut);
            smer = pom_1.uhel(idx1).hodnota;
        end

        gyro_uhel = {gyro_mereni.azimut_centr};
        gyro_delka = {gyro_mereni.delka_centr};

        for j = 1:gyro_azimut
            [~, oprava] = ZcentrujSmer(deg2rad(gyro_uhel{j}), ...
            deg2rad(gyro_uhel{j}), 0, 0, gyro_delka{j}, gyro_delka{j}, ...
            smer * gon2rad, cil_1.smer*gon2rad, centr_1.smer*gon2rad, centr_2.delka, cil_2.delka, ...
            delka_ss);
                %měřený úhlel, úhel na excentrický cíl, úhel na centr - délka na excentrický cíl a centr jsou stejné, stejný bod
                %měřený úhel na bod(záleží jestli je vlevo nebo v pravo), úhel na excentrický cíl, úhel na centr, 
            gyro_mereni(j).oprava = oprava;
        end
        [~, oprava] = ZcentrujSmer(smer*gon2rad, ...
        smer * gon2rad, cil_1.smer*gon2rad, centr_1.smer*gon2rad, centr_2.delka, cil_2.delka, ...
        deg2rad(gyro_uhel{j}), 0, 0, gyro_delka{j}, gyro_delka{j}, ...
        delka_ss);
            %měřený úhel na bod(záleží jestli je vlevo nebo v pravo), úhel na excentrický cíl, úhel na centr
            %měřený úhlel, úhel na excentrický cíl, úhel na centr - délka na excentrický cíl a centr jsou stejné, stejný bod
        opravy_smeru = [opravy_smeru; st, str2num(id_azimut), oprava/ gon2rad];
    end
end




%% Převod směrů do roviny Křovákova zobrazení
[S,U,ro1,eps] = jtsk2kar(ss(1),ss(1));
    



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

