function [delta]=CentracniZmena(psi_s1c2, psi_s1c1, psi_s1t1, e_s1t1, e_s1c1, ...
                                 psi_s2c2, psi_s2c1, psi_s2t2, e_s2t2, e_s2c2, ...
                                 s_t1t2)

   % Směry na S1
   % psi_s1c2, psi_s1c1, psi_s1t1

   % Délky na S1
   % e_s1t1, e_s1c1

   % Směry na S2
   % psi_s2c2, psi_s2c1, psi_s2t2

   % Délky na S2
   % e_s2t2, e_s2c2

   % Délka 1-2 ze souřadnic
   % s_t1t2

   % Vstup v radiánech
   omega_t1s1c2 = (psi_s1c2 - psi_s1t1);% * pi/200; %úhel na S1 mezi trigasem1 a C2 (psi C2 - psi trigas1)
   omega_c1s1t1 = (psi_s1t1 - psi_s1c1);% * pi/200; %úhel na S1 mezi C1 a trigasem1 (psi trigas1 - psi C1)


   omega_c1s2t2 = (psi_s2t2 - psi_s2c1);% * pi/200; %úhel na S2 mezi trigasem2 a C1 (psi trigas2 - psi C1)
   omega_c2s2t2 = (psi_s2t2 - psi_s2c2);% * pi/200; %úhel na S2 mezi C2 a trigasem2 (psi trigas2 - psi C2)

   %==========================================================================================================
   %|                                            0-tá iterace                                                |
   %==========================================================================================================

   %souradnice S1
   sigma_s1c2 = 0; %0 * pi/200;

   sigma_s1t1 = sigma_s1c2 - omega_t1s1c2;
   sigma_t1s1 = sigma_s1t1 + pi;
   if sigma_t1s1 > 2*pi
     sigma_t1s1 -= 2*pi;
   end

   x_s1 = e_s1t1 * cos(sigma_t1s1);
   y_s1 = e_s1t1 * sin(sigma_t1s1);

   %souradnice C1
   sigma_s1c1 = sigma_s1t1 - omega_c1s1t1;

   x_c1 = x_s1 + (e_s1c1 * cos(sigma_s1c1));
   y_c1 = y_s1 + (e_s1c1 * sin(sigma_s1c1));

   %souradnice S2
   sigma_s2c1 = pi; %200 * pi/200;

   sigma_s2t2 = sigma_s2c1 + omega_c1s2t2;
   sigma_t2s2 = sigma_s2t2 + pi;
   if sigma_t1s1 > 2*pi
     sigma_t1s1 -= 2*pi;
   end

   x_s2 = s_t1t2 + (e_s2t2 * cos(sigma_t2s2));
   y_s2 = e_s2t2 * sin(sigma_t2s2);

   %souradnice C2
   sigma_s2c2 = sigma_s2t2 - omega_c2s2t2;

   x_c2 = x_s2 + (e_s2c2 * cos(sigma_s2c2));
   y_c2 = y_s2 + (e_s2c2 * sin(sigma_s2c2));

   %==========================================================================================================
   %|                                           další iterace                                                |
   %==========================================================================================================

   sigma_s1c2_old = 0;
   sigma_s2c1_old = 0;

   while ((abs(sigma_s1c2_old-sigma_s1c2)) > (0.00001*pi/200) || (abs(sigma_s2c1_old-sigma_s2c1)) > (0.00001*pi/200))
     sigma_s1c2_old = sigma_s1c2;
     sigma_s2c1_old = sigma_s2c1;

     %souradnice S1
     sigma_s1c2 = atan2(y_c2 - y_s1, x_c2 - x_s1);

     sigma_s1t1 = sigma_s1c2 - omega_t1s1c2;
     sigma_t1s1 = sigma_s1t1 + pi;
     if sigma_t1s1 > 2*pi
       sigma_t1s1 -= 2*pi;
     end

     x_s1 = e_s1t1 * cos(sigma_t1s1);
     y_s1 = e_s1t1 * sin(sigma_t1s1);

     %souradnice C1
     sigma_s1c1 = sigma_s1t1 - omega_c1s1t1;

     x_c1 = x_s1 + (e_s1c1 * cos(sigma_s1c1));
     y_c1 = y_s1 + (e_s1c1 * sin(sigma_s1c1));

     %souradnice S2
     sigma_s2c1 = atan2(y_c1 - y_s2, x_c1 - x_s2);

     sigma_s2t2 = sigma_s2c1 + omega_c1s2t2;
     sigma_t2s2 = sigma_s2t2 + pi;
     if sigma_t1s1 > 2*pi
       sigma_t1s1 -= 2*pi;
     end

     x_s2 = s_t1t2 + (e_s2t2 * cos(sigma_t2s2));
     y_s2 = e_s2t2 * sin(sigma_t2s2);

     %souradnice C2
     sigma_s2c2 = sigma_s2t2 - omega_c2s2t2;

     x_c2 = x_s2 + (e_s2c2 * cos(sigma_s2c2));
     y_c2 = y_s2 + (e_s2c2 * sin(sigma_s2c2));
   end

   %==========================================================================================================
   %|                                          centrační změna                                               |
   %==========================================================================================================

   sigma_s1c2 = atan2(y_c2 - y_s1, x_c2 - x_s1);
   % Vracíme v radiánech
   delta = sigma_s1c2;%  * 200 / pi;

end
