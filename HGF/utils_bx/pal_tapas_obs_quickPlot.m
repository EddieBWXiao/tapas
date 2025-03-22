function pal_tapas_obs_quickPlot(r, infStates, p)

% Bowen Xiao 20250321
% quick plot of a response model given some infStates and parameters

sim_fun = str2func([r.c_obs.model, '_sim']); %e.g., tapas_sgm_choicebias_sim

if ~exist('p','var')
    p = r.p_obs.p;
end
[y, prob] = sim_fun(r, infStates, p);

figure;
plot(infStates,prob,'-');
hold on
plot(infStates,y,'o');
hold off

end