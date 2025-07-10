function [y, prob] = tapas_rl_asym_obs_sim(r, infStates, p)
% Simulates observations from an asymmetric reinforcement learning model
% with separate learning rates for positive and negative prediction errors
% Note: The infStates argument is unused in this model but kept for consistency with TAPAS interface
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Parameters in native space
v_0 = p(1);         % Initial value
alpos = p(2);       % Learning rate for positive prediction errors
alneg = p(3);       % Learning rate for negative prediction errors
invtemp = p(4);     % Inverse temperature (decision noise)

% Get inputs (rewards/correct actions)
u = r.u(:,1);

% Number of trials
n = length(u);

% Initialize
y = NaN(n,1);
prob = NaN(n,1);
Qval = NaN(n,2);    % Q-values for both actions

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% First trial: set initial Q-values and choose randomly
Qval(1,:) = [v_0, v_0];
prob(1) = 1/(1+exp(-invtemp*(Qval(1,1)-Qval(1,2)))); % Softmax choice probability
y(1) = binornd(1, prob(1));

% Subsequent trials: apply RL with asymmetric learning
for t = 2:n
    % Copy previous Q-values as default
    Qval(t,:) = Qval(t-1,:);
    
    % Get previous choice (in 1-2 coding for Q-value indexing)
    prevAct = 2 - y(t-1); % Transform from 1/0 to 1/2 coding
    
    % Get reward
    prevReward = (y(t-1) == u(t-1));
    
    % Compute prediction error
    PE = prevReward - Qval(t-1, prevAct);
    
    % Update Q-value with appropriate learning rate
    Qval(t, prevAct) = Qval(t-1, prevAct) + alpos*PE*(PE>0) + alneg*PE*(PE<0);
    
    % Compute choice probability using softmax
    prob(t) = 1/(1+exp(-invtemp*(Qval(t,1)-Qval(t,2))));
    
    % Generate choice
    y(t) = binornd(1, prob(t));
end

end