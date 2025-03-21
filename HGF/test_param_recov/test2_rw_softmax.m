addpath(genpath('../'))

% 

u = load('example_binary_input.txt');

%% settings
nsims = 200;
%u = [u;u;u;u;u];

%% load default priors
prc_config = tapas_rw_binary_config();
obs_config = tapas_softmax_config();

%% set priors
prc_config.logitalmu = 0;
prc_config.logitalsa = 1;
%obs_config.logbemu = 16;
%obs_config.logbesa = 1;

% update prior configs
prc_config = tapas_align_priors(prc_config);
%obs_config = tapas_align_priors(obs_config);

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
fitted_ze = cellfun(@(x) x.p_obs.p(1),fitted);
sim_ze = cellfun(@(x) x.p_obs.p(1),sims);
sim_al = cellfun(@(x) x.p_prc.p(2),sims);
fitted_al = cellfun(@(x) x.p_prc.p(2),fitted);

sel = true(size(fitted_ze));
sel = ~(fitted_ze < exp(2.1) & fitted_ze > exp(1.9));

figure;
subplot(1,2,1)
pal_scat_ref_corr(log(sim_ze(sel)),log(fitted_ze(sel)))
xlabel('simulated')
ylabel('fitted')
subplot(1,2,2)
pal_scat_ref_corr(sim_al(sel),fitted_al(sel))
xlabel('simulated')
ylabel('fitted')
set(gcf,'Position',[450 494 639 278])

