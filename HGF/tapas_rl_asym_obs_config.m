function c = tapas_rl_asym_obs_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for an asymmetric reinforcement learning observation model
% with separate learning rates for positive and negative prediction errors
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The asymmetric RL model has 4 parameters:
% - v_0: initial Q-value
% - alpos: learning rate for positive prediction errors
% - alneg: learning rate for negative prediction errors
% - invtemp: inverse temperature (decision noise)
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

% Model name
c.model = 'tapas_rl_asym_obs';

% Sufficient statistics of Gaussian parameter priors

% v_0 (initial Q-value) prior - in logit space (sigmoid transform)
c.logitv0mu = 0;    % Mean of prior in logit space (sigmoid(0) = 0.5)
c.logitv0sa = 0;    % Variance of prior in logit space

% alpos (learning rate for positive PEs) prior - in logit space (sigmoid transform)
c.logitalposmu = 0;  % Mean of prior in logit space (sigmoid(0) = 0.5)
c.logitalpossa = 1; % Variance of prior in logit space

% alneg (learning rate for negative PEs) prior - in logit space (sigmoid transform)
c.logitalnegmu = 0;  % Mean of prior in logit space (sigmoid(0) = 0.5)
c.logitalnegsa = 1; % Variance of prior in logit space

% invtemp (inverse temperature) prior - in log space (exponential transform)
c.loginvtempmu = log(48);  % Mean of prior in log space
c.loginvtempsa = 1;  % Variance of prior in log space

% Gather prior settings in vectors
c.priormus = [
    c.logitv0mu
    c.logitalposmu
    c.logitalnegmu
    c.loginvtempmu
         ];

c.priorsas = [
    c.logitv0sa
    c.logitalpossa
    c.logitalnegsa
    c.loginvtempsa
         ];

% Model filehandle
c.obs_fun = @tapas_rl_asym_obs;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_rl_asym_obs_transp;

return;