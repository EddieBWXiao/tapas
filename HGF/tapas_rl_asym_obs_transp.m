function [pvec, pstruct] = tapas_rl_asym_obs_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1) = tapas_sgm(ptrans(1),1);   % v_0 (initial value)
pvec(2) = tapas_sgm(ptrans(2),1);   % alpos (learning rate for positive PEs)
pvec(3) = tapas_sgm(ptrans(3),1);   % alneg (learning rate for negative PEs)
pvec(4) = exp(ptrans(4));           % invtemp (inverse temperature)

pstruct.v_0 = pvec(1);
pstruct.alpos = pvec(2);
pstruct.alneg = pvec(3);
pstruct.invtemp = pvec(4);

return;