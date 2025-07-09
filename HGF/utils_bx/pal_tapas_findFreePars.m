function [prc_ind, obs_ind, n_par, par_names, n_prc_pars, n_obs_pars] = pal_tapas_findFreePars(r)

% find the free parameters in an est struct
% Modified from tapas_fit_plotCorr by Bowen Xiao, Jun 2025
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

% Determine numerical indices of parameters to optimize (i.e., those that are not fixed and not NaN)

prc_ind = r.c_prc.priorsas;
prc_ind(isnan(prc_ind)) = 0;
prc_ind = find(prc_ind);

obs_ind = r.c_obs.priorsas;
obs_ind(isnan(obs_ind)) = 0;
obs_ind = find(obs_ind);

% count the number of free parameters
n_prc_pars = length(prc_ind);
n_obs_pars = length(obs_ind);
n_par   =  n_prc_pars + n_obs_pars;

% get the names of the free parameters
[expnms_prc, expnms_obs] = pal_tapas_getParNames(r);
par_names = {[expnms_prc(prc_ind); expnms_obs(obs_ind)]}; %select only the free pars

end