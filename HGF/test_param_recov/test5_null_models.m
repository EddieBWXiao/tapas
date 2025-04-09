addpath(genpath('../'))

% Bowen Xiao 20250321
% testing the null models

u = load('example_binary_input.txt');

%% settings
nsims = 50;
%u = u(1:20); %will actually reassuringly help see the strips; panel 3 will have strinkage
%u = [u;u;u;u;u];

%% load default priors
prc_config = tapas_no_learning_config();
obs_config = tapas_random_choice_config();

%% set priors
%prc_config.muconstmu = 0;
%prc_config.muconstsa = 0;
obs_config.logitbiasmu = 0;
obs_config.logitbiassa = 1;

% update prior configs
prc_config = tapas_align_priors(prc_config);
obs_config = tapas_align_priors(obs_config);

%% configure the fitting
optim_config = tapas_quasinewton_optim_config();
optim_config.nRandInit = 0; %multiple initializations for optimization?
optim_config.maxIter = 10000; % iteration, increased from 100;
optim_config.maxRst = 100; %max reset, increased from 10;

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
  {'p_obs.p(1)', 'p_prc.p(1)'}, ...
  {'bias', 'dummy'});
subplot(2,2,3)
bias_real = cellfun(@(x) mean(x.y), sims);
bias_par = pal_tapas_getProp(fitted, 'p_obs.bias');
pal_scat_ref_corr(bias_par,bias_real)
xlabel('bias parameter')
ylabel('prop y==1')
set(gcf, 'Position', [450 296 519 476])
