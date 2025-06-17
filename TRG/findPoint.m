function [Y,X] = findPoint(ss,point,sequence)
%   [Y, X] = FINDPOINT(SS, POINT) searches in matrix SS for rows where the
%   first column equals POINT. It returns the values from the first column
%   as Y and the second column as X (default behavior).
%
%   Inputs:
%       SS       - Nx2 matrix containing data points.
%       POINT    - Value to search for in SS(:,1).
%       SEQUENCE - (Optional) If 1 sequnce [Y,X]
%                         If not 1 sequnce [X,Y] 
%
%   Outputs:
%       Y - Column vector of values from SS based on SEQUENCE.
%       X - Column vector of values from SS based on SEQUENCE.
    if nargin == 2
        sequence = 1;
    end
    r = find(ss(:,1)==point);

    if sequence == 1
        Y = ss(r,1);
        X = ss(r,2);
    else
        Y = ss(r,2);
        X = ss(r,1);
    end
end 