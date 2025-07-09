function pal_tapas_fit_plotChoiceRT(r, usedLogRTms, nsims)
% Plots the choice probabilities and reaction times for the fitted model
% Usage example:  est = tapas_fitModel(...); pal_tapas_fit_plotChoiceRT(est);
% Bowen Xiao 2025
%
% Used Claude to help follow the aesthetic conventions of tapas_ehgf_plotTraj

% next step: use Hess & potentially create the credible interval for RT

%% default
if ~exist('usedLogRTms','var')
    usedLogRTms = false;
end

if ~exist('nsims','var')
    % Number of simulations for RT predictions
    nsims = 100;
end


%%


% Extract data
u = r.u;
chose_y1 = r.y(:,1);
rt_data = r.y(:,2);

% Get model predictions
if all(isnan(r.optim.yhat))
    % Call the model functions if yhat is NaN
    disp('NaN for yhat. Calling model functions')
    [~, infStates] = r.c_prc.prc_fun(r, r.p_prc.ptrans, 'trans');
    [~, yhat] = r.c_obs.obs_fun(r, infStates, r.p_obs.ptrans);
else
    yhat = r.optim.yhat;
end

% Generate RT simulations
rt_sims = nan(size(yhat,1),nsims);
for j = 1:nsims
    the_sim = pal_tapas_est2sim(r);
    rt_sims(:,j) = the_sim.y(:,2);
end

% Deal with logRTms
if usedLogRTms
    rt_sims = exp(rt_sims)/1000;
    rt_data = exp(rt_data)/1000;
    yhat(:,2) = exp(yhat(:,2))/1000;
end

%% plotting
% Set up display
scrsz = get(0,'screenSize');
outerpos = [0.2*scrsz(3), 0.2*scrsz(4), 0.8*scrsz(3), 0.8*scrsz(4)];
figure(...
    'OuterPosition', outerpos,...
    'Name', 'Choice and RT trajectories');

% Time axis
if size(r.u,2) > 1 && ~isempty(find(strcmp(fieldnames(r.c_prc),'irregular_intervals'))) && r.c_prc.irregular_intervals
    t = r.u(:,end)';
else
    t = ones(1, size(r.u,1));
end

ts = cumsum(t); %trials
ts = [0, ts]; % add 0 to front

% Choice probabilities subplot with input visualization
subplot(2,1,1);
plot(ts(2:end), yhat(:,1), 'b', 'LineWidth', 2);
hold all;
plot(ts(2:end), chose_y1, 'o', 'Color', [1 0.7 0], 'MarkerSize', 8);
plot(ts(2:end), 1.16*r.u(:,1)-0.08, '.', 'Color', [0 0.6 0], 'MarkerSize', 6); % inputs in green
xlim([0 ts(end)]);
ylim([-0.15 1.15]); % Extended range to accommodate irregular markers
title('Choice probabilities: p(y=1) (blue), actual choices (hollow orange), input u (solid green)', 'FontWeight', 'bold');
ylabel('Choice probability');
hold off;

% Reaction times subplot
subplot(2,1,2);
plot(ts(2:end), rt_data, 'k-', 'LineWidth', 1);
hold all;
plot(ts(2:end), mean(rt_sims, 2), 'r', 'LineWidth', 2);
plot(ts(2:end), yhat(:, 2), 'b--', 'LineWidth', 2);
xlim([0 ts(end)]);
title('Reaction times: actual RT (thin black), mean sim RT (red), analytic RT (blue dashed)', 'FontWeight', 'bold');
ylabel('Reaction time (s)');
xlabel({'Trial number', ' '}); % A hack to get the relative subplot sizes right
hold off;


end