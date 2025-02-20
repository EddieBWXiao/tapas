addpath(genpath('../'))

% simplify recovery pipeline by using tapas_sampleModel
% check issue with high learning rates (high al) -- failure to recover??

u = load('example_binary_input.txt');

%% settings
nsims = 1000;
%u = [u;u;u;u;u];

%% configure the priors
prc_config = tapas_rw_binary_config();
obs_config = tapas_unitsq_sgm_config();

% priors:
prc_config.logitalmu = 0;
prc_config.logitalsa = 1;
obs_config.logzesa = 1;
obs_config.logzemu = 1;

% update prior configs
prc_config = tapas_align_priors(prc_config);
obs_config = tapas_align_priors(obs_config);

% configure the fitting
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
%sel = fitted_ze < exp(2);
figure;
subplot(1,2,1)
plot(log(sim_ze(sel)),log(fitted_ze(sel)),'o')
title(corr(log(sim_ze(sel)),log(fitted_ze(sel))))
xlabel('simulated')
ylabel('fitted')
refline([1 0])
subplot(1,2,2)
plot(sim_al(sel),fitted_al(sel),'o')
title(corr(sim_al,fitted_al))
xlabel('simulated')
ylabel('fitted')
refline([1 0])
set(gcf,'Position',[450 494 639 278])

