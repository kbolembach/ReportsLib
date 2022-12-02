function [unc] = UncB(delta_x, vars)
%UNCB Zwraca niepewność standardową typu B dla niepewności przyrządu
%pomiarowego.
%Dla parsowania pojedynczej wartości użyj:
%u_b(wektor_delt)
%Dla parsowania wielu wartości(wektora) względem tych samych delt, użyj: 
% u_b(wektor_delt, wektor_wielkosci)
if (nargin == 1)
    unc_sq = sum( ((delta_x).^2) ./ 3);
    unc = RoundUnc(sqrt(unc_sq));
end
if (nargin == 2)
    for i=length(vars):-1:1
        unc(i) = RoundUnc(sqrt(sum( ((delta_x).^2) ./ 3)));
    end
end
end