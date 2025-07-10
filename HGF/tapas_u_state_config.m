function c = tapas_u_state_config

% Contains the configuration for the prc model for basic dm
% Copyright (C) 2025 Bowen Xiao Uni of Cam

% ini config structure
c = struct;
c.model = 'tapas_u_state';

% dummy parameter
c.pnullmu = 0;
c.pnullsa = 0;

c.priormus = c.pnullmu;
c.priorsas = c.pnullsa;

% Model filehandle
c.prc_fun = @tapas_u_state;
% transformation function
c.transp_prc_fun = @tapas_u_state_transp;

end
