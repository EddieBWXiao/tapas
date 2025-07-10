function [y, prob] = tapas_noisy_asym_wsls_sim(r, infStates, p)
% Simulates observations from a noisy asymmetric win-stay lose-shift model
% Note: The infStates argument is unused in this model but kept for consistency with TAPAS interface
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% sim: no transformation, just the p
epsilon_win = p(1);
epsilon_loss = p(2);

% Get inputs (rewards/correct actions)
u = r.u(:,1);

% Number of trials
n = length(u);

% Initialize
y = NaN(n,1);
prob = NaN(n,1);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% First trial: random choice with p=0.5
prob(1) = 0.5;
y(1) = binornd(1, prob(1));

% Subsequent trials: apply win-stay lose-shift strategy with asymmetric noise
for t = 2:n
    % Get previous choice and reward
    prevChoice = y(t-1);
    prevReward = (y(t-1) == u(t-1));
    
    if prevReward == 1
        % win-stay: if prevChoice was 1, stay with high probability
        if prevChoice == 1
            prob(t) = 1 - epsilon_win/2;  % stay with action 1
        else
            prob(t) = epsilon_win/2;      % stay with action 0 (low prob of switching to 1)
        end
    else
        % lose-shift: If prevChoice was 1, shift with high probability
        if prevChoice == 1
            prob(t) = epsilon_loss/2;      % shift from action 1 to 0 (low prob of staying with 1)
        else
            prob(t) = 1 - epsilon_loss/2;  % shift from action 0 to 1
        end                
    end
    
    % Generate choice
    y(t) = binornd(1, prob(t));
end

end