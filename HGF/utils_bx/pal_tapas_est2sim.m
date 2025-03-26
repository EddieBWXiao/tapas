function sim = tapas_est2sim(est)

% as the name suggests
% turn est output from tapas_fitModel into a simulation

% Input validation and return of []: TBD
if isempty(est)
    disp('warning: empty input') %somehow warning cannot be printed??
    sim = [];
    return
end

sim = tapas_simModel(est.u,...
    func2str(est.c_prc.prc_fun),...
    est.p_prc.p,...
    func2str(est.c_obs.obs_fun),...
    est.p_obs.p);

end