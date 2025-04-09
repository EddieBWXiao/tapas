function c = tapas_no_learning_config

% Contains the configuration for a "null model" with no learning
% Copyright (C) 2025 Bowen Xiao Uni of Cam

% ini config structure
c = struct;
c.model = 'tapas_no_learning';

% dummy parameter
c.muconstmu = 0;
c.muconstsa = 0;

c.priormus = c.muconstmu;
c.priorsas = c.muconstsa;

% Model filehandle
c.prc_fun = @tapas_no_learning;
% transformation function
c.transp_prc_fun = @tapas_no_learning_transp;

end
