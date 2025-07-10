function [pvec, pstruct] = tapas_u_state_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1) = ptrans(1);
pstruct.pnull = pvec(1);

end