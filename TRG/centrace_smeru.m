function [theta] = centrace_smeru(ss,st1,st2,st_1_sm_2,st_1_sm_ce,st_1_sm_ci,st_1_d_ce,st_1_d_ci,st_2_sm_1,st_2_sm_ce,st_2_sm_ci,st_2_d_ce,st_2_d_ci)
    %%
    % ss - seznam souřadnic
    % st1 - číslo stanoviska 1
    % st2 - číslo stanoviska 2

    % st_1_sm_2 - směr ze st1 na st2
    % st_1_sm_ce - směr na centr (st1)
    % st_1_sm_ci - směr na ex-cíl (st1)
    % st_1_d_ce - délka na centr (st1)
    % st_1_d_ci - délka na ex-cíl (st1)

    % st_2_sm_1 - směr ze st2 na st1
    % st_2_sm_ce - směr na centr (st2)
    % st_2_sm_ci - směr na ex-cíl (st2)
    % st_2_d_ce - délka na centr (st2)
    % st_2_d_ci - délka na ex-cíl (st2)
    %%
    [X_1002,Y_1002] = findPoint(ss, st1);
    [X_1001,Y_1001] = findPoint(ss, st2);

    %% Příprava potřebných bodů
    st_1001 = [ones(3,1)*Y_1001, ones(3,1)*X_1001];
    st_1002 = [ones(3,1)*Y_1002, ones(3,1)*X_1002];

    % Iteration parameters
    maxIter = 100;     % maximum number of iterations
    tol     = 1e-6;    % convergence tolerance
    
    for k = 1:maxIter
        % Store old values to check convergence
        st1_old = st_1001;
        st2_old = st_1002;
    
        % Update positions
        st_1001 = compute_positions(st_1_sm_ce, st_1_sm_2, st_1_sm_ci, ...
                                     st_1_d_ce, st_1_d_ci, st_1001, st_1002);
    
        st_1002 = compute_positions(st_2_sm_ce, st_2_sm_1, st_2_sm_ci, ...
                                     st_2_d_ce, st_2_d_ci, st_1002, st_1001);
    
        % Check convergence (if both st_1001 and st_1002 barely change)
        if max(abs(st_1001(:) - st1_old(:))) < tol && ...
           max(abs(st_1002(:) - st2_old(:))) < tol
            break;
        end
    end
    
    theta = angle_between_lines(st_1001(1,:), st_1002(1,:), st_1001(3,:),st_1002(2,:));
    
    
    
    function st_1001 = compute_positions(st_1_sm_ce, st_1_sm_2, st_1_sm_ci, ...
                                         st_1_d_ce, st_1_d_ci, ...
                                         st_1001, st_1002)
    
        % --- Step 1: Angle w1 ---
        t = 0; % flag for mirroring
        L_R = 0;
        w1 = st_1_sm_ce - st_1_sm_2;
        w1(w1 < 0) = w1(w1 < 0) + 2*pi;
        
        % If angle > pi, mirror it and mark
        if w1 > pi
            w1 = 2*pi - w1;
            t = 1;
        end
        
        % --- Step 2: Distance between st_1001(2,:) and st_1002(1,:) ---
        delka_ss = sqrt((st_1001(2,1) - st_1002(1,1))^2 + ...
                        (st_1001(2,2) - st_1002(1,2))^2);
        
        % --- Step 3: Angles w2, w3 ---
        w2 = asin(sin(w1) / delka_ss * st_1_d_ce);
        w3 = pi - (w1 + w2);
        
        % --- Step 4: First sigma ---
        sig_1 = atan2(st_1002(1,1) - st_1001(1,1), ...
                      st_1002(1,2) - st_1001(1,2));
        sig_1(sig_1 < 0) = sig_1(sig_1 < 0) + 2*pi;
        
        % --- Step 5: Adjust sigma depending on t ---
        if t == 1
            sig_1 = sig_1 + w3;
        else
            sig_1 = sig_1 - w3;
        end
        
        % --- Step 6: Compute st_1001(3,:) ---
        st_1001(3,1) = st_1001(1,1) + st_1_d_ce * sin(sig_1);
        st_1001(3,2) = st_1001(1,2) + st_1_d_ce * cos(sig_1);
        
        % --- Step 7: Update sigma based on st_1001(3,:) ---
        sig_1 = atan2(st_1001(1,1) - st_1001(3,1), ...
                      st_1001(1,2) - st_1001(3,2));
        sig_1(sig_1 < 0) = sig_1(sig_1 < 0) + 2*pi;
        
        % Left and right
        if st_1001(1,1)>st_1001(3,1)
            L_R = 1;
        end
        
        % --- Step 8: Angle w4 ---
        if L_R == 0
            w4 = st_1_sm_ce - st_1_sm_ci;
            w4(w4 < 0) = w4(w4 < 0) + 2*pi;
            
            % --- Step 9: Final sigma ---
            sig_1 = sig_1 - w4;
            sig_1(sig_1 < 0) = sig_1(sig_1 < 0) + 2*pi;
            sig_1(sig_1 > 2*pi) = sig_1(sig_1 > 2*pi) - 2*pi;
        else
            w4 = st_1_sm_ci - st_1_sm_ce;
            w4(w4 < 0) = w4(w4 < 0) + 2*pi;
            
            % --- Step 9: Final sigma ---
            sig_1 = sig_1 + w4;
            sig_1(sig_1 > 2*pi) = sig_1(sig_1 > 2*pi) - 2*pi;
            sig_1(sig_1 < 0) = sig_1(sig_1 < 0) + 2*pi;
        end
        
        
        % --- Step 10: Compute st_1001(2,:) ---
        st_1001(2,1) = st_1001(3,1) + st_1_d_ci * sin(sig_1);
        st_1001(2,2) = st_1001(3,2) + st_1_d_ci * cos(sig_1);
    end
    
    function angle_rad = angle_between_lines(p1, p2, p3, p4)
    % SIGNED_ANGLE_BETWEEN_LINES Calculates the signed angle between two lines
    %   Line1: p1 -> p2
    %   Line2: p3 -> p4
    %
    %   Input:  p1, p2, p3, p4 as 1x2 vectors [x y]
    %   Output: signed angle in degrees (-180° .. +180°)
    
        % Create direction vectors
        v1 = p2 - p1;
        v2 = p4 - p3;
    
        % Normalize
        v1 = v1 / norm(v1);
        v2 = v2 / norm(v2);
    
        % Dot and cross product
        dot_val = dot(v1, v2);
        cross_val = v1(1)*v2(2) - v1(2)*v2(1); % 2D cross product (z-component)
    
        % Clamp dot product
        dot_val = max(min(dot_val,1),-1);
    
        % Angle in radians with sign
        angle_rad = atan2(cross_val, dot_val);
    
    end
end