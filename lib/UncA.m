function [unc] = UncA(xi, round)
%UNCA Zwraca niepewność standardową typu A (pomiary powtórzone n-krotnie)
%dla danych wejściowych x_i. round = "exact" dla niezaokrąglonego wyniku.
n = length(xi);
xbar = mean(xi);
nom = sum( (xi-xbar).^2 );
denom = n.*(n-1);
if nargin == 2
    if round == "exact"
        unc = sqrt(nom./denom);
    end
else
    unc = RoundUnc(sqrt(nom./denom));
end
end