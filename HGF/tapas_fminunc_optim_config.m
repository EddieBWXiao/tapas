function c = tapas_fminunc_optim_config
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Configuration for wrapper around MATLAB's fminunc (see if faster)
%
% CAVEAT:
% to update the fminunc options, requires:
% est.c_opt.fminuncOptions = optimoptions(est.c_opt.fminuncOptions, 'Display', 'iter');
% this keeps the previous options
% or... use dot notation (est.c_opt.fminuncOptions.Display)
% calling optimoptions will erase previous settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2025 Bowen Xiao, PaL Lab, University of Cambridge
% Intends to be part of the HGF toolbox

% Config structure
c = struct;

% Algorithm name
c.algorithm = 'fminunc wrapper';

% Verbosity
c.verbose   = false;

% Options related to tapas_fitModel, not native to fminunc
c.nRandInit = 0;        % Number of random initializations
c.seedRandInit = NaN;   % Seed for random initialization

% Check the Hessian to prevent LME in complex numbers
c.check_hessian = true;

% IMPORTANT: customise the optimoptions here
% defaults to the default as of December 2025, with Display off to reduce verbosity
% Please note that verbose = true will not turn Display back on; please do so manually
c.fminuncOptions = optimoptions('fminunc',...
    'Algorithm','quasi-newton',...
    'Display','off');
    %'MaxFunctionEvaluations', 1e6,... %the default is 100*n_params, which is low
    %'Display','off');

% Algorithm filehandle
c.opt_algo = @tapas_fminunc_optim;

return;