function c = tapas_sgm_wsls_cbstick_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for the sigmoid observation model with choice bias, stickiness, and WSLS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The sigmoid with choice bias, stickiness, and win-stay/lose-shift model uses:
%
% p(y=1|mu1hat) = sigmoid(zeta * (logit(mu1hat) + bias + stickiness * prev_choice + 
%                                 wsbonus * y1win + lsbonus * y1loss))
%
% where:
% - zeta > 0 is the inverse decision noise (steepness parameter)
% - bias is a constant choice bias term (can be positive or negative)
% - stickiness captures the tendency to repeat previous choices
% - wsbonus is the win-stay bonus (positive values encourage repeating rewarded choices)
% - lsbonus is the lose-shift bonus (positive values encourage switching after unrewarded choices)
% - y1win/y1loss encode the reward history and previous choice interaction
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
c.model = 'tapas_sgm_wsls_cbstick';

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

% Win-stay bonus - positive values encourage repeating rewarded choices
c.wsbonusmu = 0;
c.wsbonussa = 1;

% Lose-shift bonus - positive values encourage switching after unrewarded choices  
c.lsbonusmu = 0;
c.lsbonussa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
    c.biasmu,...
    c.stickmu,...
    c.wsbonusmu,...
    c.lsbonusmu,...
         ];

c.priorsas = [
    c.logzesa,...
    c.biassa,...
    c.sticksa,...
    c.wsbonussa,...
    c.lsbonussa,...
         ];

% Model filehandle
c.obs_fun = @tapas_sgm_wsls_cbstick;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_sgm_wsls_cbstick_transp;

return;