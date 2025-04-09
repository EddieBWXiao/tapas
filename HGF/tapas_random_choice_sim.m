function [y, prob] = tapas_random_choice_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution with fixed probability
% random response model
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Based on code by Christoph Mathys, TNU, UZH & ETHZ
% Modified by Bowen Xiao from tapas_sgm_choicebias_sim
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Get number of trials
n = size(infStates, 1);

% params
bias = p(1); % this is already transformed! (confusing difference for _sim vs the likelihood func)

% Fixed probability for all trials
prob = bias * ones(n, 1);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate binary choices
y = binornd(1, prob);

end