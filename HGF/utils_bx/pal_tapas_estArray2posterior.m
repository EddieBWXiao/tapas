function posterior = pal_tapas_estArray2posterior(ests)

% WORK-IN-PROGRESS
% from an array of est structs, get group-level posterior of parameters

% steps:
% use pal_tapas_findFreePars(r)
% get vec of mean and variance from ptrans and pvec

% (okay maybe from this step onwards we will make another func...)
% assign value to ptrans in a config that we will use
% turn ptrans into pvec? (wait, priormus are ptrans right??)
% tapas_align_priors_fields(cfg) %hope this func works with no bug
% then the new cfg can be used for par rec and other stuff

[prc_ind, obs_ind, n_par, par_names] = cellfun(@(x)pal_tapas_findFreePars(x),...
    ests,'UniformOutput',false);

%% check: all the same for params?
% Convert cell arrays to matrices
prc_ind_mat = cell2mat(prc_ind);
obs_ind_mat = cell2mat(obs_ind);
n_par_mat = cell2mat(n_par);
% Check if all rows are equal for each matrix
prc_rows_equal = all(all(prc_ind_mat == prc_ind_mat(1,:), 2));
obs_rows_equal = all(all(obs_ind_mat == obs_ind_mat(1,:), 2));
n_par_rows_equal = all(all(n_par_mat == n_par_mat(1,:), 2));
par_names_extracted = cellfun(@(x) x{1}, par_names, 'UniformOutput', false);
par_names_equal = all(cellfun(@(x) isequaln(x, par_names_extracted{1}), par_names_extracted));
if any([~prc_rows_equal,~obs_rows_equal,~n_par_rows_equal,~par_names_equal])
    disp('Warning: cell array has different contents after applying pal_tapas_findFreePars.')
end

%% record the free param indices
posterior.prc_ind = prc_ind_mat(1,:);
posterior.obs_ind = obs_ind_mat(1,:);
posterior.free_pars = par_names_extracted{1};

%% actually extract the transformed params; take mean and SD
posterior.prc_ptrans = cell2mat(cellfun(@(x) x.p_prc.ptrans, ests, 'UniformOutput',false));
posterior.obs_ptrans = cell2mat(cellfun(@(x) x.p_obs.ptrans, ests, 'UniformOutput',false));
posterior.prc_pvec = cell2mat(cellfun(@(x) x.p_prc.p, ests, 'UniformOutput',false));
posterior.obs_pvec = cell2mat(cellfun(@(x) x.p_obs.p, ests, 'UniformOutput',false));

posterior.prc_ptrans_mu = mean(posterior.prc_ptrans, 1);
posterior.prc_ptrans_sa = std(posterior.prc_ptrans, [], 1); %note: this could be non-zero for fixed pars due to numerical precision...
posterior.obs_ptrans_mu = mean(posterior.obs_ptrans, 1);
posterior.obs_ptrans_sa = std(posterior.obs_ptrans, [], 1);

%okay I don't think pvec will be any useful but export since we are already here
posterior.prc_pvec_mu = mean(posterior.prc_pvec, 1);
posterior.prc_pvec_sa = std(posterior.prc_pvec, [], 1);
posterior.obs_pvec_mu = mean(posterior.obs_pvec, 1);
posterior.obs_pvec_sa = std(posterior.obs_pvec, [], 1);

end