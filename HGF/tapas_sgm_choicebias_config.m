function c = tapas_sgm_choicebias_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for a sigmoid observation model with a choice bias term, for binary responses
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The sigmoid curve
% p(x) = 1./(1+exp(be*x)) 
%
% be: inverse temperature
%
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
% Modified Bowen Xiao 2025 from unitsq_sgm
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
c.model = 'tapas_unitsq_sgm';

% Sufficient statistics of Gaussian parameter priors

% Zeta
c.logzemu = log(48);
c.logzesa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
         ];

c.priorsas = [
    c.logzesa,...
         ];

% Model filehandle
c.obs_fun = @tapas_unitsq_sgm;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_unitsq_sgm_transp;

return;
