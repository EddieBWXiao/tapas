addpath(genpath('../'))

% 
u = load('example_binary_input.txt');

%u = repmat(u,[3,1]); %increase length;
    % note that _hgf_, not _ehgf_, seems to fail more if u lengthened...

nsims = 10;

%% model
prc_config = tapas_ehgf_binary_config();
obs_config = tapas_sgm_choicebias_config();
%prc_params = {};

%% get bopars on input

bopars = tapas_fitModel([],...
                         u,...
                         prc_config,...
                         'tapas_bayes_optimal_binary_config',...
                         'tapas_quasinewton_optim_config');

%% set priors

%prc_config.priormus = bopars.p_prc.p; %nope this won't update with align_priors?
prc_config.ommu = bopars.p_prc.om;
prc_config.omsa = [NaN 4 4]; %tighten priors if needed; 16 for hgf 4 for ehgf

obs_config.logzemu = 0;
obs_config.logzesa = 1;

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
tapas_hgf_binary_plotTraj(sim1)
tapas_hgf_binary_plotTraj(fit1)

%% loop for recovery
% preallocate
sims = cell(nsims,1);   
fitted = cell(nsims,1);
failure_count = 0;
max_attempts = 1000; % Set a maximum number of attempts to prevent infinite loops

% loop
i = 1;
while i <= nsims && failure_count < max_attempts
    
    try
        %fprintf('Running simulation %d/%d (attempt %d)...\n', i, nsims, attempt);
        sim_result = tapas_sampleModel(u,...
            prc_config,...
            obs_config);
        
        sims{i} = sim_result;
        
        fitted{i} = tapas_fitModel(sims{i}.y,...
            u,...
            prc_config,...
            obs_config,...
            optim_config);
        
        i = i + 1; % Only increment i if both simulation and fitting succeed
        
    catch ME
        
        failure_count = failure_count + 1;
        fprintf('Attempt failed; this is failure no. %i \n', failure_count);
        % log more details about the error
        disp(getReport(ME));
        
    end
end
fprintf('Completed %d/%d simulations with %d failures\n', i-1, nsims, failure_count);

% Check if we got all the simulations we wanted
if i <= nsims
    warning('Could only complete %d out of %d requested simulations after %d attempts', i-1, nsims, attempt-1);
end

%% plotting
pal_tapas_plotParRecAll(sims, fitted, ...
  {'p_obs.p(1)', 'p_prc.om(2)', 'p_prc.om(3)', 'p_obs.p(2)'}, ...
  {'logspace \zeta', '\omega_2', '\omega_3', 'choice bias'}, ...
  {@log, [], [], []});

set(gcf, 'Position', [450 296 519 476])

