function [result] = pdArr(F, arglist)
%PDARR Zwraca tablicę z pochodnymi cząstkowymi funkcji F względem zmiennych z
%tablicy arglist.
for j = 1:length(arglist)
    result(j) = {matlabFunction(diff(F, arglist(j)), 'Vars', {arglist})};
end
end

