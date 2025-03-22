function c = tapas_sgm_choicebias_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contains the configuration for a sigmoid observation model with a choice bias term, for binary responses
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The sigmoid curve:
% p(x) = 1./(1+exp(ze*x)) 
% 
% If x is logit(m), with m being a probability... then this should be
% equivalent to the unit-square sigmoid over m
%
% With option to include choice bias in logit space:
% decision_var = logit(m) + bias
% p(m) = 1./(1+exp(ze*decision_var)) 
% 
% ze: inverse temperature zeta, scaling the decision_var in logit space
% bias: a response bias term in logit space, for choice options not side
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
c.model = 'tapas_sgm_choicebias';

% Sufficient statistics of Gaussian parameter priors

% Zeta % standard normal used as default, unlike unitsq_sgm
c.logzemu = 0;
c.logzesa = 1;
% Bias
c.biasmu = 0;
c.biassa = 1;

% Gather prior settings in vectors
c.priormus = [
    c.logzemu,...
    c.biasmu
         ];

c.priorsas = [
    c.logzesa,...
    c.biassa
         ];

% Model filehandle
c.obs_fun = @tapas_sgm_choicebias;

% Handle to function that transforms observation parameters to their native space
% from the space they are estimated in
c.transp_obs_fun = @tapas_sgm_choicebias_transp;

return;
