function [fit, a, u_a] = LinRegNoIntercept(x,y)
%LINREG Dla danych wejściowych x, y przeprowadza w prosty sposób regresje
%liniową. Zwraca kolejno model regresji liniowej fit, współczynik
%kierunkowy prostej najlepszego dopasowania a oraz jego niepewność u_a,
%Wersja NoIntercept zapewnia wyraz wolny b = 0.
%Funkcja wypisuje także te wartości na ekran wraz z R^2.

if isa(x, 'Quantity')
    x = GetValue(x, 1);
end

if isa(y, 'Quantity')
    y = GetValue(y,1);
end


fit = fitlm(x,y,'Intercept', false); 
a = fit.Coefficients.Estimate(1);
u = diag(sqrt(fit.CoefficientCovariance));
u_a = u(1);

u_a = sym(RoundUnc(u_a));
a = sym(RoundMes(a, u_a));
A = Quantity("A", a, sym(1), u_a);
disp('Regresja');
disp('a = ' + A.Print());
disp('b = 0');
disp('R^2 = ' + string(fit.Rsquared.Adjusted));
disp(" ");

end

