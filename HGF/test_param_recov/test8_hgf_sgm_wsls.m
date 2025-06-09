addpath(genpath('../'))

% testing 2l HGF
%
u = load('example_binary_input.txt');

%% settings
nsims = 20;
%u = u(1:20); %will actually reassuringly help see the strips; panel 3 will have strinkage
%u = [u;u;u];

%% load default priors
prc_config = tapas_ehgf_binary_config();
obs_config = tapas_sgm_wsls_cbstick_config();

%% get bopars on input
% bopars = tapas_fitModel([],...
%                          u,...
%                          prc_config,...
%                          'tapas_bayes_optimal_binary_config',...
%                          'tapas_quasinewton_optim_config');

%% set priors
prc_config.ommu = [NaN -2.8961 0.1183]; %manual for the full Iglesias u
prc_config.omsa = [NaN 4 0]; %tighten priors if needed; 16 for hgf 4 for ehgf

obs_config.logzemu = 0;
obs_config.logzesa = 1;
obs_config.biasmu = 0;
obs_config.biassa = 1; % do not free the bias in this recovery attempt
obs_config.stickmu = 0;
obs_config.sticksa = 0; % try to turn this on and off
% focus on the wsls, which are default free
%obs_config.wsbonussa = 0; % try freeze this
obs_config.lsbonussa = 0; % try freeze this

% update prior configs
prc_config = tapas_align_priors(prc_config);
obs_config = tapas_align_priors(obs_config);

%% configure the fitting
optim_config = tapas_quasinewton_optim_config();
optim_config.nRandInit = 2; %multiple initializations for optimization?
optim_config.maxIter = 200; % iteration, increased from 100;
optim_config.maxRst = 20; %max reset, increased from 10;

%% loop for recovery
% preallocate
sims = cell(nsims,1);   
fitted = cell(nsims,1);
% use for loop
for i = 1:nsims
    sims{i} = tapas_sampleModel(u,...
        prc_config,...
        obs_config);
    
    fitted{i} = tapas_fitModel(sims{i}.y,...
        u,...
        prc_config,...
        obs_config,...
        optim_config);
end

%% plotting
% pal_tapas_plotParRecAll(sims, fitted, ...
%   {'p_obs.p(1)', 'p_prc.om(2)', 'p_obs.p(4)', 'p_obs.p(3)'}, ...
%   {'logspace \zeta', '\omega_2', 'win-stay bonus', 'stickiness'}, ...
%   {@log, [], [], []});
% set(gcf, 'Position', [450 296 519 476])

pal_tapas_plotParRecAll(sims, fitted, ...
  {'p_obs.p(1)', 'p_prc.om(2)', 'p_obs.p(4)', 'p_obs.p(5)'}, ...
  {'logspace \zeta', '\omega_2', 'win-stay bonus', 'lose-shift bonus'}, ...
  {@log, [], [], []});

set(gcf, 'Position', [450 296 519 476])
