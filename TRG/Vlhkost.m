function RH = Vlhkost(t, t_w, p)
% t, t_w v °C, p v hPa
% Výstup RH v %

% Funkce na saturaci páry (Magnus)
p = p * 1.33322368;
A = 6.112; B = 17.62; C = 243.12;
p_s_t = A * exp(B .* t ./ (C + t));
p_s_tw = A * exp(B .* t_w ./ (C + t_w));

% Psychrometrický koeficient A_p
A_p = 0.00066 .* (1 + 0.00115 .* t);

% Napjatost par e
e = p_s_tw - A_p .* p .* (t - t_w);

RH = (e ./ p_s_t) * 100;
end
