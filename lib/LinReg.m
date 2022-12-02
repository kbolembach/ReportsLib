function [fit, a, u_a, b, u_b] = LinReg(x,y)
%LINREG Dla danych wejściowych x, y przeprowadza w prosty sposób regresje
%liniową. Zwraca kolejno model regresji liniowej fit, współczynik
%kierunkowy prostej najlepszego dopasowania a oraz jego niepewność u_a,
%wyraz wolny prostej b i jego niepewność u_b.
%Funkcja wypisuje także te wartości na ekran wraz z R^2.

if isa(x, 'Quantity')
    x = GetValue(x, 1);
end

if isa(y, 'Quantity')
    y = GetValue(y,1);
end


fit = fitlm(x,y);
a = fit.Coefficients.Estimate(2);
b = fit.Coefficients.Estimate(1);
u = diag(sqrt(fit.CoefficientCovariance));
u_a = u(2);
u_b = u(1);

u_a = sym(RoundUnc(u_a));
a = sym(RoundMes(a, u_a));
A = Quantity("A", a, sym(1), u_a);
disp('Regresja');
disp('a = ' + A.Print());
u_b = RoundUnc(u_b);
b = RoundMes(b, u_b);
B = Quantity("B", b, sym(1), u_b);
disp('b = ' + B.Print());
disp('R^2 = ' + string(fit.Rsquared.Adjusted));
disp(" ");

end

