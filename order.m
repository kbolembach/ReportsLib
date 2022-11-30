function [n] = order(val, base)
%ORDER Oblicza rząd wielkości liczby val względem podstawy base (10).
if nargin < 2
    base = 10;
end
n = floor(round((log(abs(val))./log(base)),15));
end

