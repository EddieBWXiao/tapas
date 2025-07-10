function c = tapas_noisy_asym_wsls_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for a noisy asymmetric win-stay lose-shift observation model for binary responses
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The noisy asymmetric WSLS model:
% - If win (y==u): stay with probability 1-epsilon_win/2
% - If loss (y~=u): shift with probability 1-epsilon_loss/2
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
c.model = 'tapas_noisy_asym_wsls';

% Sufficient statistics of Gaussian parameter priors

% epsilon_win (noise parameter after win) prior - in logit space
c.logitepsilonwinmu = 0;  % Mean of prior in logit space (sigmoid(0) = 0.5)
c.logitepsilonwinsa = 1;  % Variance of prior in logit space

% epsilon_loss (noise parameter after loss) prior - in logit space
c.logitepsilonlossmu = 0;  % Mean of prior in logit space (sigmoid(0) = 0.5)
c.logitepsilonlosssa = 1;  % Variance of prior in logit space

% Gather prior settings in vectors
c.priormus = [
    c.logitepsilonwinmu
    c.logitepsilonlossmu
         ];

c.priorsas = [
    c.logitepsilonwinsa
    c.logitepsilonlosssa
         ];

% Model filehandle
c.obs_fun = @tapas_noisy_asym_wsls;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_noisy_asym_wsls_transp;

return;