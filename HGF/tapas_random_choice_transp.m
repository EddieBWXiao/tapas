function [pvec, pstruct] = tapas_random_choice_transp(r, ptrans)
% --------------------------------------------------------------------------------------------------
% Copyright (C) 2025 Based on code by Christoph Mathys, TNU, UZH & ETHZ
% Modified by Bowen Xiao from tapas_sgm_choicebias_transp
%
% This file is part of the HGF toolbox, which is released under the terms of the GNU General Public
% Licence (GPL), version 3. You can redistribute it and/or modify it under the terms of the GPL
% (either version 3 or, at your option, any later version). For further details, see the file
% COPYING or <http://www.gnu.org/licenses/>.

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1) = tapas_sgm(ptrans(1),1); %sigmoid-transform the logit into native
pstruct.bias = pvec(1);

return;