function [pvec, pstruct] = tapas_sgm_cbstick_transp(r, ptrans)
% Transforms parameters from estimation space to native space
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)       = exp(ptrans(1));    % ze (inverse decision noise)
pvec(2)       = ptrans(2);         % bias (no transformation)
pvec(3)       = ptrans(3);         % stickiness (no transformation)

pstruct.ze    = pvec(1);
pstruct.bias  = pvec(2);
pstruct.stick = pvec(3);

return;