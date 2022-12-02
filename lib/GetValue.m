function out = GetValue(vals, separate_units)
%GETVALUE Dla tablicy [vals] zwraca pole 'Value' każdego jej elementu.
%   out = GetValue(vals, separate_units)
%   
%   vals - tablica wielkości fizycznych
%   separate_units - dla 1 zwraca wynik jako tablicę double

if nargin == 1
    out = arrayfun(@(x) getfield(x, 'Value'), vals);
elseif nargin == 2
   if separate_units == 1
       out = arrayfun(@(x) double(separateUnits(getfield(x, 'Value'))), vals);
   else
       out = arrayfun(@(x) getfield(x, 'Value'), vals);
   end
end
end