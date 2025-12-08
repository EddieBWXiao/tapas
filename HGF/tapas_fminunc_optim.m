function optim = tapas_fminunc_optim(f, init, varargin)
% wrapper function around MATLAB fminunc
% wrapped by Bowen Xiao Dec 2025

% INPUT:
%     f            Function handle of the function to be optimised
%     init         The point at which to initialize the algorithm
%     varargin     Optional settings structure that can contain the
%                  following fields:
%       verbose    Boolean flag to turn output on (true) or off (false)
%       other arguments to pass into fminun (see _config)
%
% OUTPUT:
%     optim        Structure containing results in the following fields
%       valMin     The value of the function at its minimum
%       argMin     The argument of the function at its minimum
%       T          The inverse Hessian at the minimum calculated as a
%                  byproduct of optimization
%       iter       stores the output output of fmincon
% --------------------------------------------------------------------------------------------------
% 2025 Bowen Xiao, PaL Lab, University of Cambridge
% Intends to be part of the HGF toolbox

% The default arguments to fmincon; use options to override
verbose = false;
check_hessian = true;
fminuncOptions = optimoptions('fminunc'); 
if nargin > 2
    options = varargin{1};

    if isfield(options, 'verbose')
        verbose = options.verbose;
    end
    
    if isfield(options, 'check_hessian')
        check_hessian = options.check_hessian;
    end
    
    if isfield(options, 'fminuncOptions')
        fminuncOptions = options.fminuncOptions;
    end
end

% Make sure init is a column vector
if ~iscolumn(init)
    init = init';
    if ~iscolumn(init)
        error('tapas:hgf:FminuncOptim:InitPointNotRow', 'Initial point has to be a row vector.');
    end
end

% Initial value for display and iteration tracking
val = f(init);

if verbose
    disp(' ')
    disp(['Initial argument: ', num2str(init')])
    disp(['Initial value: ' num2str(val)])
end

% Call fmincon

[x_opt,fval,~,output,~,hessian] = fminunc( ...
        f, init, fminuncOptions);

%disp(['fminunc terminated with exitflag ' num2str(exitflag)])
%disp(output.message) %intuitive message for quick inspection

% Compute T_opt from the Hessian
% Slightly awkward because the one place that uses it inverts it again, with loss of numerical precision
T_opt = [];
hessian_invalid = any(isnan(hessian(:))) || any(isinf(hessian(:)));
if hessian_invalid
    disp('Warning: Hessian invalid (contains NaN or Inf); may result in undefined Sigma in tapas_fitModel if the alternative Hessian also fails there')
else
    T_opt = inv(hessian);
end
output.hessian_fminunc = hessian; %store the original hessian as a copy

% Additional check on the Hessian (Bowen Xiao 20241205)
if check_hessian && ~hessian_invalid
    % When the T_opt is used to compute the LME...
    % tapas_fitModel catches Hessians that are not positive semi-definite
    % and uses tapas_nearest_psd, which checks the eigenvalues
    % however, it computes LME based on det(H), which can still be negative
    % [yes, for some reason, ~any(eig(X) < 0), can still have det(H)<0 ???]
    % the complex LME prodcued may appear larger than LMEs from other initializations, despite a more problematic Hessian
    % The following code forces the optimization result to be Inf, leading to -Inf LME
    % Users may use new random initializations to explore the parameter space and potentially identify a better Hessian
    H = inv(T_opt);
    H = tapas_nearest_psd(H);
    if det(H) < 0
        disp('Warning: det(H)<0; Hessian not positive semi-definite. If final LME = -Inf, increase nRandInit.')
        fval = Inf;
    end
end

% Collect results
optim.valMin = fval;
optim.argMin = x_opt;
if ~isempty(T_opt)
    optim.T = T_opt;
end
optim.iter = output; % only field to store other optimiser-related info

return;