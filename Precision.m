function [result] = Precision(val, precentage, n, LSB)
%PRECISION Oblicza dokładność pomiarową.
%> val - wartość mierzona;
%> precentage - procent z wartości mierzonej (z tablic);
%> n - liczba stojąca przy "dgt";
%> LSB - najmniej znacząca cyfra (nie jej rząd, należy podawać wartości
%        jako np. 10^(-5).

result = (val.*precentage)./100 + n.*LSB;
end

