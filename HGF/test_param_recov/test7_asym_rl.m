addpath(genpath('../'))

% testing noisy wsls

u = load('example_binary_input.txt');

%% settings
nsims = 40;
%u = u(1:20); %will actually reassuringly help see the strips; panel 3 will have strinkage
%u = [u;u;u];

%% load default priors
prc_config = tapas_no_learning_config();
obs_config = tapas_rl_asym_obs_config();

%% set priors
obs_config.logitv0mu = -1000; % 0 the v0

% update prior configs
prc_config = tapas_align_priors(prc_config);
obs_config = tapas_align_priors(obs_config);

%% configure the fitting
optim_config = tapas_quasinewton_optim_config();
optim_config.nRandInit = 5; %multiple initializations for optimization?
optim_config.maxIter = 200; % iteration, increased from 100;
optim_config.maxRst = 50; %max reset, increased from 10;

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
pal_tapas_plotParRecAll(sims, fitted, ...
  {'p_obs.p(2)','p_obs.p(3)', 'p_obs.p(4)'}, ...
  {'alpha-positive','alpha-negative', 'inverse temperature'});
set(gcf, 'Position', [450 296 519 476])
