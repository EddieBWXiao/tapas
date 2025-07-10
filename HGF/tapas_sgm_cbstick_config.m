function c = tapas_sgm_cbstick_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the sigmoid observation model with choice bias and stickiness
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The sigmoid with choice bias and stickiness model uses a logistic sigmoid function with
% additional parameters for choice bias and choice stickiness:
%
% p(y=1|mu1hat) = sigmoid(zeta * (logit(mu1hat) + bias + stickiness * prev_choice))
%
% where:
% - zeta > 0 is the inverse decision noise (steepness parameter)
% - bias is a constant choice bias term (can be positive or negative)
% - stickiness captures the tendency to repeat previous choices
% - prev_choice is coded as +1 for previous y=1, -1 for previous y=0, 0 for irregular trials
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Is the decision based on predictions or posteriors? Comment as appropriate.
c.predorpost = 1; % Predictions
%c.predorpost = 2; % Posteriors

% Model name
c.model = 'tapas_sgm_cbstick';

% Sufficient statistics of Gaussian parameter priors

% Zeta (inverse decision noise) - log-transformed to ensure positivity
c.logzemu = log(48);
c.logzesa = 1;

% Choice bias - can be positive or negative, no transformation needed
c.biasmu = 0;
c.biassa = 1;

% Stickiness parameter - can be positive or negative, no transformation needed
c.stickmu = 0;
c.sticksa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
    c.biasmu,...
    c.stickmu,...
         ];

c.priorsas = [
    c.logzesa,...
    c.biassa,...
    c.sticksa,...
         ];

% Model filehandle
c.obs_fun = @tapas_sgm_cbstick;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_sgm_cbstick_transp;

return;