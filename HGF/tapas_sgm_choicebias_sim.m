function [y, prob] = tapas_sgm_choicebias_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution for a sigmoid function with bias
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
% Modified Bowen Xiao 2025 from unitsq_sgm 
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

% params
ze = p(1); %inverse temperature
bias = p(2); % bias term;

% Assumed structure of infStates:
% dim 1: time (ie, input sequence number)
% dim 2: HGF level
% dim 3: 1: muhat, 2: sahat, 3: mu, 4: sa

% Belief trajectories at 1st level
x = squeeze(infStates(:,1,pop));

% Apply the sigmoid function to the inferred states
x_real = log(x./(1-x)); %IMPORTANT: transform probability to logit space
prob = tapas_sgm(ze * (x_real+bias), 1);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = binornd(1, prob);

end
