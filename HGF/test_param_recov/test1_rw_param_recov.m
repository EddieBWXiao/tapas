addpath(genpath('../'))

u = load('example_binary_input.txt');

%% settings
nsims = 100;
%u = [u;u;u;u;u];

%% configure the priors

prc_config = tapas_rw_binary_config();
obs_config = tapas_unitsq_sgm_config();

% the following reached 0.86 & 0.91 in recovery, but still a 0.66 plateau for LR:
% prc_config.logitalsa = 0.5;
% obs_config.logzesa = 3;
% obs_config.logzemu = 1;

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
optim_config.nRandInit = 5; %multiple initializations for optimization?
optim_config.maxIter = 10000; % iteration, increased from 100;
optim_config.maxRst = 100; %max reset, increased from 10;

%% set parameters for simulations
logisticf = @(x) 1./(1+exp(-x));
%al_range = logisticf(normrnd(0,1,[nsims,1]));
al_range = unifrnd(0,1,[nsims,1]);
zeta_range = normrnd(obs_config.priormus(1),obs_config.priorsas(1),[nsims,1]);
while any(zeta_range<0)
    ind_replace = zeta_range<0;
    zeta_range(ind_replace) = normrnd(obs_config.priormus(1),obs_config.priorsas(1),[sum(ind_replace),1]);
end

%% loop for recovery
% preallocate
sims = cell(nsims,1);
fitted = cell(nsims,1);
% use for loop
for i = 1:nsims
    sims{i} = tapas_simModel(u,...
        'tapas_rw_binary',...
        [0.5, al_range(i)],... 
        'tapas_unitsq_sgm',...  - note that this will run _sim which doesn't transform the value
        zeta_range(i));
    
    %fitted{i} = fit_tanx_wrapper('rw_binary_unitsq_sgm',y,u);
    fitted{i} = tapas_fitModel(sims{i}.y,...
        u,...
        'tapas_rw_binary_config',...
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

