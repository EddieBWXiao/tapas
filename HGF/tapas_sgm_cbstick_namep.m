function pstruct = tapas_sgm_cbstick_namep(pvec)
% Creates a struct with named fields for each parameter
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Bowen Xiao
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pstruct = struct;

pstruct.ze    = pvec(1);   % Inverse decision noise
pstruct.bias  = pvec(2);   % Choice bias
pstruct.stick = pvec(3);   % Choice stickiness

return;