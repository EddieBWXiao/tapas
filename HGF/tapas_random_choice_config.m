function c = tapas_random_choice_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for a random choice observation model with a fixed bias parameter
% for binary responses
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The model has a single parameter:
% bias: a fixed probability of choosing option 1, independent of any input
%
% The parameter is estimated in logit space and transformed to probability space (0-1) using:
% p(y=1) = 1/(1+exp(-logitbias))
% 
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Based on code by Christoph Mathys, TNU, UZH & ETHZ
% Modified by Bowen Xiao from tapas_sgm_choicebias_config
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Config structure
c = struct;

% Model name
c.model = 'tapas_random_choice';

% Sufficient statistics of Gaussian parameter prior
% Bias (in logit space)
c.logitbiasmu = 0;    % Prior mean of 0 in logit space corresponds to p=0.5
c.logitbiassa = 1;    % Prior variance

% Gather prior settings in vectors
c.priormus = c.logitbiasmu;
c.priorsas = c.logitbiassa;

% Model filehandle
c.obs_fun = @tapas_random_choice;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_random_choice_transp;

return;