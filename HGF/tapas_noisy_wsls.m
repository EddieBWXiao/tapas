function [logp, yhat, res] = tapas_noisy_wsls(r, infStates, ptrans)
% Calculates the log-probability of response y=1 for a noisy win-stay lose-shift model
% Will use r.y and r.u from previous trial
% assume irregular is in y and NOT in u!!!
% 
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao 
% inspiration from https://github.com/AnneCollins/TenSimpleRulesModeling/blob/master/LikelihoodFunctions/lik_M2WSLS_v1.m
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform bias parameter to native space (probability between 0 and 1)
% using sigmoid transform of the parameter
logitepsilson = ptrans(1);
epsilon = tapas_sgm(logitepsilson, 1);

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1); %Note that we still use infStates here for the trial number!!
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% IMPORTANT: standard code problematic for using y(t-1), need to adapt...
% so we are not weeding irregular trials out from responses just yet
y_full = r.y;
u_full = r.u;

% find the probability of generating the choice y==1 and not y==0
p_y1 = NaN(length(y_full), 1); % initialize p_y1 vector (probability of y==1)
for t = 1:length(y_full)
    if ismember(t, r.irr)
        % skip probability calculation for irregular trials
        % the p_y1 here remains NaN
        continue;
    end
    
    if t == 1
        % first trial: random choice with p=0.5
        p_y1(t) = 0.5;
    else
        % all other trials: 
        if ismember(t-1, r.irr)
            % IMPORTANT: this handles when the previous trial has no y!
            if u_full(t-1) == 1
                % if previously 1 was rewarded, go 1
                p_y1(t) = 1 - epsilon/2;
            else
                % if previously 0 was rewarded, go 0
                p_y1(t) = epsilon/2;
            end
            
        else
            % Get previous choice and reward
            prevChoice = y_full(t-1);
            prevReward = y_full(t-1) == u_full(t-1); 
            
            if prevReward == 1
                % win-stay: if prevChoice was 1, stay with high probability
                if prevChoice == 1
                    p_y1(t) = 1 - epsilon/2;  % stay with action 1
                else
                    p_y1(t) = epsilon/2;      % stay with action 0 (low prob of switching to 1)
                end
            else
                % lose-shift: If prevChoice was 1, shift with high probability
                if prevChoice == 1
                    p_y1(t) = epsilon/2;      % shift from action 1 to 0 (low prob of staying with 1)
                else
                    p_y1(t) = 1 - epsilon/2;  % shift from action 0 to 1
                end                
            end
            
        end
        
    end
end

% Handle numerical issues
p_y1 = min(max(p_y1, eps), 1-eps);

% Weed out the irregular trials here
reg = ~ismember(1:n,r.irr);
y = y_full(reg);
p_y1(r.irr) = [];

% Get probability of observed choice
p_choice = p_y1 .* (y==1) + (1-p_y1) .* (y~=1); 

% Calculate log-probabilities for non-irregular trials
logp(reg) = log(p_choice);

% Set predicted responses to the bias probability (constant for all trials)
% Still need to check how this affects other tapas_ features!!! (not sure
% where yhat and res are generally used)
% Note: unlike models that depend on input states, here yhat is constant...
yhat(reg) = p_y1; 
res(reg) = -logp(reg);

return;