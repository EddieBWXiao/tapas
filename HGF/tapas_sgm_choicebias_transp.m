function [pvec, pstruct] = tapas_sgm_choicebias_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2012-2013 Christoph Mathys, TNU, UZH & ETHZ
% Modified Bowen Xiao 2025 for sgm_choicebias
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)    = exp(ptrans(1));         % be, come back from log transform
pvec(2)    = ptrans(2);  
pstruct.ze = pvec(1);
pstruct.bias = pvec(2);

return;