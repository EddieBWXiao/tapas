function [logp, yhat, res] = tapas_sgm_choicebias(r, infStates, ptrans)
% Calculates the log-probability of response y=1 for sigmoid response
% function with a choice bias term
% 
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
% modified by Bowen Xiao 2025 from tapas_unitsq_sgm
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Predictions or posteriors?
pop = 1; % Default: predictions
if r.c_obs.predorpost == 2
    pop = 3; % Alternative: posteriors
end

% Transform zeta to its native space
ze = exp(ptrans(1));
bias = ptrans(2);

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from inferred states and responses
x = infStates(:,1,pop);
x(r.irr) = [];
y = r.y(:,1);
y(r.irr) = [];

% logit transform x from 0~1 to -Inf~Inf; can be Inf but will be sorted in
% sgm, since tapas_sgm(Inf, 1) = 1 and tapas_sgm(-Inf,1) = 0
% ensures when x=0.5, p(choice) is also 0.5
x_real = log(x./(1-x));

% the sigmoid function:
p_y1 = tapas_sgm(ze * (x_real+bias), 1);

% deal with numerical issues: if close to 0 or 1, turn into eps or 1-eps
% p_y1((p_y1 - 0) < eps) = eps; 
% p_y1((1 - p_y1) < eps) = 1-eps;
p_y1 = min(max(p_y1, eps), 1-eps); % does the two lines above more efficiently; tic toc verified

% get probability of each resp based on if y==1 or not
p_choice = p_y1 .* (y==1) + (1-p_y1) .* (y~=1); 

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(p_choice); 
yhat(reg) = x;
res(reg) = -logp(reg); % not sure what to do about this -- copied _softmax_...

return;
