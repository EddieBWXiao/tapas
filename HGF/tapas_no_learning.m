function [traj, infStates] = tapas_no_learning(r, p, varargin)

% a "null model" with no learning
% fixed belief trajectory
%
% difference from tapas_u_state: constant infStates rather than passing u forward
% infStates still passes on information about the number of trials

% Copyright (C) 2025 Bowen Xiao Uni of Cam

% unpack the dummy placeholder parameter
muconst = p(1); % constant belief

% n observations
n_trials = length(r.u(:,1));

% constant belief trajectory, fixed at the parameter
traj.mu  = muconst*ones(n_trials, 1);
infStates = traj.mu;

end