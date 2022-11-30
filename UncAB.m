function [unc] = UncAB(ua, ub)
%UNCAB Zwraca niepewność standardową całkowitą na podstawie wyliczonych wcześniej już typów A oraz B
unc = RoundUnc(sqrt( ua.^2 + ub.^2 ));
end

