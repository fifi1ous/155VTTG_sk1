function [X1,B1,L1,X2,B2,L2,X3,B3,L3,X4,B4,L4]=nejblizsi4(B,L,sloupec,matice)
rr1 = 100;
rr2 = 100;
rr3 = 100;
rr4 = 100;
for i = 1 : size(matice,1)
  Bi = matice(i,1);
  Li = matice(i,2);
  Xi = matice(i,sloupec);
  deltaB = Bi - B;
  deltaL = Li - L;
  r = acos(sin(B * pi / 180) * sin(Bi * pi / 180) + cos (B * pi / 180) * cos(Bi * pi / 180) * cos(deltaL * pi / 180));
  if ((deltaL < 0) && (deltaB > 0))
    if (rr1 > r)
      rr1 = r;
      B1 = Bi;
      L1 = Li;
      X1 = Xi;
    end
  end
  if ((deltaL > 0) && (deltaB > 0))
    if (rr2 > r)
      rr2 = r;
      B2 = Bi;
      L2 = Li;
      X2 = Xi;
    end
  end
  if ((deltaL < 0) && (deltaB < 0))
    if (rr3 > r)
      rr3 = r;
      B3 = Bi;
      L3 = Li;
      X3 = Xi;
    end
  end
  if ((deltaL > 0) && (deltaB < 0))
    if (rr4 > r)
      rr4 = r;
      B4 = Bi;
      L4 = Li;
      X4 = Xi;
    end
  end
end