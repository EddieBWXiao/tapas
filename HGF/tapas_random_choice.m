function [logp, yhat, res] = tapas_random_choice(r, infStates, ptrans)
% Calculates the log-probability of response y=1 for a random choice model
% with a fixed bias parameter
% 
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Based on code by Christoph Mathys, TNU, UZH & ETHZ
% Modified by Bowen Xiao from tapas_sgm_choicebias
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Transform bias parameter to native space (probability between 0 and 1)
% using sigmoid transform of the parameter
logitbias = ptrans(1);
bias = tapas_sgm(logitbias, 1);

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1); %Note that we still use infStates here for the trial number!!
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from responses
y = r.y(:,1);
y(r.irr) = [];

% Fixed probability of choosing y=1, regardless of input states
p_y1 = bias * ones(size(y));

% Handle numerical issues
p_y1 = min(max(p_y1, eps), 1-eps);

% Get probability of observed choice
p_choice = p_y1 .* (y==1) + (1-p_y1) .* (y~=1); 

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(p_choice);

% Set predicted responses to the bias probability (constant for all trials)
% Still need to check how this affects other tapas_ features!!! (not sure
% where yhat and res are generally used)
% Note: unlike models that depend on input states, here yhat is constant...
yhat(reg) = bias; 
res(reg) = -logp(reg);

return;