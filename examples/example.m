tic
clear all; close all; clc;
addpath('..\lib')
if isfile('output.txt')
    delete 'output.txt'; 
end
u = symunit;
diary output.txt; diary on

%% Stałe
output_mode = "single";
e = Quantity.Constant("e", sym(1.602 * 10^(-19)));
h = Quantity.Constant("h", 6.626070 * 10^(-34) * u.J * u.s);
c = Quantity.Constant("c", 299792458 * u.m / u.s);
hc = Quantity.Constant("hc", sym(1.98644586 * 10^(-25)));

%% Równania
an_quadratic = @(a, b, c) c - (b^2 / (4*a));
an_x0 = @(a, b) -b/(2*a);
an_DeltaU = @(U2, U1) U2 - U1;
an_E = @(e, deltaU) e *  deltaU;
an_lambda = @(hc, E) hc / E;

%% Pomiary 
excel = 'data.xlsx';

raw_U = readmatrix(excel, 'Range', 'B3:B115'); % V
raw_I = readmatrix(excel, 'Range', 'C3:C115'); % nA

%% Przetwarzanie
for i=length(raw_U):-1:1 
   I(i) = Quantity.B("I", "p", raw_I(i), raw_I(i) * 0.05 * sqrt(3), index=i, output=output_mode);
   U(i) = Quantity.B("U", "p", raw_U(i), raw_U(i) * 0.05 * sqrt(3), index=i, output=output_mode); 
end


%% Obliczenia
%piki na indeksie (57-71)64, (88-95)91 przbylizyć jako f. kwadratowa

x2 = raw_U(82:95);
dense_x2 = linspace(x2(1), x2(end), 100);
y2 = raw_I(82:95);

fit2 = fitlm(x2, y2, 'poly2');
num_a2 = fit2.Coefficients.Estimate(3);
num_b2 = fit2.Coefficients.Estimate(2);
num_c2 = fit2.Coefficients.Estimate(1);
uu = diag(sqrt(fit2.CoefficientCovariance));
u_a2 = uu(3);
u_b2 = uu(2);
u_c2 = uu(1);

polyval_y2 = polyval([num_a2, num_b2, num_c2], dense_x2);
x2_max = an_x0(num_a2, num_b2);
y2_max = an_quadratic(num_a2, num_b2, num_c2);

a2 = Quantity("a", num_a2, 1, u_a2);
b2 = Quantity("b", num_b2, 1, u_b2);
c2 = Quantity("c", num_c2, 1, u_c2);
U_max(2) =  Quantity.C(an_x0, "U_max", [a2, b2], self_uncertainty = 0.05/sqrt(3));
I_max(2) = Quantity.C(an_quadratic, "I_max", [a2, b2, c2], self_uncertainty = 0.05/sqrt(3));

%drugi pik:

x1 = raw_U(57:72);
dense_x1 = linspace(x1(1), x1(end), 100);
y1 = raw_I(57:72);

fit1 = fitlm(x1, y1, 'poly2');
num_a1 = fit1.Coefficients.Estimate(3);
num_b1 = fit1.Coefficients.Estimate(2);
num_c1 = fit1.Coefficients.Estimate(1);
uu = diag(sqrt(fit1.CoefficientCovariance));
u_a1 = uu(3);
u_b1 = uu(2);
u_c1 = uu(1);

polyval_y1 = polyval([num_a1, num_b1, num_c1], dense_x1);
x1_max = an_x0(num_a1, num_b1);
y1_max = an_quadratic(num_a1, num_b1, num_c1);

a1 = Quantity("a", num_a1, 1, u_a1);
b1 = Quantity("b", num_b1, 1, u_b1);
c1 = Quantity("c", num_c1, 1, u_c1);

U_max(1) =  Quantity.C(an_x0, "U_max", [a1, b1], self_uncertainty = 0.05/sqrt(3));
I_max(1) = Quantity.C(an_quadratic, "I_max", [a1, b1, c1], self_uncertainty = 0.05/sqrt(3));

DeltaU = Quantity.C(an_DeltaU, "DeltaU", [U_max(2), U_max(1)]); 
E = Quantity.C(an_E, "E", [e, DeltaU]);
lambda = Quantity.C(an_lambda, "lambda", [hc, E]);

%% Wykres
figure
hold on
plot(dense_x1, polyval_y1, '-b');
plot(x1_max, y1_max, '+r');
plot(dense_x2, polyval_y2, '-b');
plot(x2_max, y2_max, '+r');
Plot(U, I, "I = f(U)", "U [V]", "I [nA]", ["przyblizenie", "maksimum", '', ...
    '', "pomiary"], 0); 
hold off
diary off
toc

%% Tabela

WriteLatexTable("table.txt", ...
    ["L.p.", "$ U $",  "$ I $"  , "L.p.", "$ U $",  "$ I $"  ], ...
    ["",     " $V $",  "$ nA  $", "",     " $V $",  "$ nA  $"], ...
    [[1:57].' U(1:57).Print().', I(1:57).Print().', ...
    [[58:113], ""].', [U(58:113).Print(), ""].', [I(58:113).Print(), ""].', ... 
              ]);