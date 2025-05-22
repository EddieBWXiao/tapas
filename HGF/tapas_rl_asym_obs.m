function [logp, yhat, res] = tapas_rl_asym_obs(r, infStates, ptrans)
% Write the Palminteri-esque asymmetric RL, only in observation model
% No perc model until I figure out if r.y accessible in prc
% 
% Will use r.y and r.u from previous trial
% assume irregular is in y and NOT in u!!!
% 
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao 
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform params
v_0 = tapas_sgm(ptrans(1), 1);
alpos  = tapas_sgm(ptrans(2), 1);
alneg  = tapas_sgm(ptrans(3), 1);
invtemp  = exp(ptrans(4));

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1); %Note that we still use infStates here for the trial number!!
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

Qval  = NaN(n,2); %following Palminteri-esque
PE  = NaN(n,1);

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
    
    % learning part
    if t == 1
        % first trial: random choice with p=0.5
        Qval(t,:) = [v_0, v_0];
    else
        % all other trials: 
        Qval(t, :) = Qval(t-1, :);%copy the Q values and modify later
        if ~ismember(t-1, r.irr)
            % for standard trials where the previous was NOT missing
            
            % Get previous choice and reward
            prevAct = 2 - y_full(t-1); % switch from 1 0 to 1 2 code here!!
            prevReward = y_full(t-1) == u_full(t-1); 
            
            
            % compute PE & update the chosen Q value
            PE(t) = prevReward - Qval(t-1, prevAct);
            Qval(t, prevAct) = Qval(t-1, prevAct) + alpos*PE(t)*(PE(t)>0) + alneg*PE(t)*(PE(t)<0);
            
        else
            % IMPORTANT: this handles when the previous trial has no y!
   
            % we can just keep the previous Q value?
            
        end
        
    end
    
    % decision making part:
    p_y1(t) = 1/(1+exp(-invtemp*(Qval(t,1)-Qval(t,2))));
    
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