function [y, prob] = tapas_sgm_cbstick_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution with choice bias and stickiness
% 
% A VERY BIG "small" PROBLEM: not doing one-step look-ahead, just
% using the simulated y for the stickiness part
% don't think TAPAS can handle the one-step look-ahead issue well?
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
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

% Parameters
ze = p(1);         % Inverse decision temperature
bias = p(2);       % Choice bias
stickiness = p(3); % Choice stickiness

% Assumed structure of infStates:
% dim 1: time (ie, input sequence number)
% dim 2: HGF level
% dim 3: 1: muhat, 2: sahat, 3: mu, 4: sa

% Belief trajectories at 1st level
x = squeeze(infStates(:,1,pop));
n = length(x);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Initialize output
y = NaN(n,1);
prob = NaN(n,1);

% Simulate trial by trial to account for choice history
for t = 1:n
    % Logit transform x from 0~1 to -Inf~Inf
    x_real = log(x(t)/(1-x(t)));
    
    % Choice history term
    % Different from the likelihood function's .shift()-like syntax because...
    % ...y was generated from the previous trial on the fly
    if t == 1
        choice_trace_diff = 0; % No previous choice
    else
        prev_choice = y(t-1);
        choice_trace_diff = (prev_choice == 1) * 1 + (prev_choice == 0) * (-1);
    end
    
    % Calculate probability of choosing y=1
    prob(t) = tapas_sgm(ze * (x_real + bias + stickiness * choice_trace_diff), 1);
    
    % Simulate choice
    y(t) = binornd(1, prob(t));
end

end