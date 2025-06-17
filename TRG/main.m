clc; clear; format long G


ss = load("pribl_sour_jtsk.txt");

data = parse_trgsit_xml("trg_format_dat.xml");


[S,U,ro1,eps] = jtsk2kar(ss(1),ss(1));
    

