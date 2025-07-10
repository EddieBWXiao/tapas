function [pvec, pstruct] = tapas_no_learning_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1) = ptrans(1);
pstruct.muconst = pvec(1);

end