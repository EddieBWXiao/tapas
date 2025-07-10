function [traj, infStates] = tapas_u_state(r, p, varargin)

% prc model for basic decision-making
% also a "null model" with no learning
% obs will simply use u on each trial as the inferred state
%
% Unlike e.g., rw_, there is no shift in u (i.e., no dummy "zeroth" trial)
% Suitable for being coupled to decision-making models
% However, win-stay lose-shift etc. should NOT use the infStates from here!

% Copyright (C) 2025 Bowen Xiao Uni of Cam

% % unpack the dummy placeholder parameter (not necessary...)
% pnull = p(1);

% IMPORTANT: traj and inferred states simply follow the observations, u
traj.v  = r.u;
infStates = traj.v;

end