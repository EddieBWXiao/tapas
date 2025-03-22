addpath(genpath('../'))

% Bowen Xiao 20250321
% test of observation model sgm_choicebias 

% 
u = load('example_binary_input.txt');

%% settings
nsims = 100;
%u = [u;u;u;u;u];

%% load default priors
prc_config = tapas_rw_binary_config();
obs_config = tapas_sgm_choicebias_config();

%% set priors

%important: behaviour not distinguishable for LR>0.5 with high be?

prc_config.logitalmu = 0; %for high be, can be -1; [logit(0.25) gives -1.0986]
prc_config.logitalsa = 1;
obs_config.logzemu = 0;
obs_config.logzesa = 3; %works with just 1; losen still okay
obs_config.biasmu = 0;
obs_config.biassa = 10; %works with just 1; losen still okay

% update prior configs
prc_config = tapas_align_priors(prc_config);
obs_config = tapas_align_priors(obs_config);

%% configure the fitting
optim_config = tapas_quasinewton_optim_config();
optim_config.nRandInit = 0; %multiple initializations for optimization?
optim_config.maxIter = 10000; % iteration, increased from 100;
optim_config.maxRst = 100; %max reset, increased from 10;

%% try a single fit
sim1 = tapas_sampleModel(u,...
    prc_config,...
    obs_config);

fit1 = tapas_fitModel(sim1.y,...
    u,...
    prc_config,...
    obs_config,...
    optim_config);

% visualise the learning model
tapas_rw_binary_plotTraj(sim1)
tapas_rw_binary_plotTraj(fit1)

% visualise response model properties:
pal_tapas_obs_quickPlot(sim1, (0:0.01:1)',[0.5, 0])

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
fitted_ze = cellfun(@(x) x.p_obs.p(1),fitted);
sim_ze = cellfun(@(x) x.p_obs.p(1),sims);
sim_al = cellfun(@(x) x.p_prc.p(2),sims);
fitted_al = cellfun(@(x) x.p_prc.p(2),fitted);
sim_bias = cellfun(@(x) x.p_obs.p(2),sims);
fitted_bias = cellfun(@(x) x.p_obs.p(2),fitted);

sel = true(size(fitted_ze));

figure;
subplot(2,2,1)
pal_scat_ref_corr(log(sim_ze(sel)),log(fitted_ze(sel)))
xlabel('simulated')
ylabel('fitted')
subplot(2,2,2)
pal_scat_ref_corr(sim_al(sel),fitted_al(sel))
xlabel('simulated')
ylabel('fitted')
subplot(2,2,3)
pal_scat_ref_corr(sim_bias(sel),fitted_bias(sel))
xlabel('simulated')
ylabel('fitted')
set(gcf,'Position',[450 296 519 476])

