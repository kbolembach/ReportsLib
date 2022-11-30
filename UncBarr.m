function [unc] = UncBarr(delta_x, vars)
%Zwraca niepewność standardową typu B dla niepewności przyrządu pomiarowego
%Dla parsowania pojedynczej wartości użyj:
%u_b(wektor_delt)
%Dla parsowania wielu wartości(wektora) względem tych samych delt, użyj: 
% u_b(wektor_delt, wektor_wielkosci)
if (nargin == 1)
    unc_sq = sum( ((delta_x).^2) ./ 3);
    unc = RoundUnc(sqrt(unc_sq));
end
if (nargin == 2)
    unc = zeros(length(vars),1);
    for i = 1:length(vars)
        unc(i) = UncB(delta_x(i));
    end
end
end