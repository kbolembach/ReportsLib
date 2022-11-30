function out = GetUncertainty(vals, separate_units)
%GETUNCERTAINTY Dla tablicy [vals] zwraca pole 'unc' każdego jej elementu.
%   out = GetUncertainty(vals, separate_units)
%   
%   vals - tablica wielkości fizycznych
%   separate_units - dla 1 zwraca wynik jako tablicę double

if nargin == 1
out = arrayfun(@(x) getfield(x, 'Uncertainty'), vals);
elseif nargin == 2
   if separate_units == 1
       out = arrayfun(@(x) double(separateUnits(getfield(x, 'Uncertainty'))), vals);
   else
       out = arrayfun(@(x) getfield(x, 'Uncertainty'), vals);
   end
end
end

