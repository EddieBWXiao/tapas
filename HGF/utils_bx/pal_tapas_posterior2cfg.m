function [prc_config, obs_config] = pal_tapas_posterior2cfg(posterior, prc_config, obs_config, round_to)

% input: posterior should be the output of pal_tapas_estArray2posterior
% assign value to ptrans in a config that we will use
% tapas_align_priors_fields(cfg) %hope this func works with no bug
% then the new cfg can be used for par rec and other stuff

% round(,), rather than taking the whole float; prevents error of accidentally freeing a parameter
if ~exist('round_to', 'var')
    round_to = 6;
end

if isempty(prc_config)
   do_prc = false; 
   prc_config = struct;
else
   do_prc = true;
end
if isempty(obs_config)
   do_obs = false; 
   obs_config = struct;
else
   do_obs = true;
end

if do_prc
    if ~strcmp(posterior.c_prc.model, prc_config.model)
        error('ERROR: model in posterior different from model in prc_config')
    end
    prc_config.priormus(:) = round(posterior.prc_ptrans_mu(:),round_to);
    prc_config.priorsas(:) = round(posterior.prc_ptrans_sa(:),round_to);
    prc_config = tapas_align_priors_fields(prc_config);
    
end

if do_obs
    if ~strcmp(posterior.c_obs.model, obs_config.model)
        error('ERROR: model in posterior different from model in obs_config')
    end
    obs_config.priormus(:) = round(posterior.obs_ptrans_mu(:),round_to);
    obs_config.priorsas(:) = round(posterior.obs_ptrans_sa(:),round_to);
    obs_config = tapas_align_priors_fields(obs_config);
end

end




