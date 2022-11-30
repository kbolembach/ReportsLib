function out = GetLatexName(vals)
%GETVALUE Dla tablicy [vals] zwraca pole 'Name' każdego jej elementu.

out = arrayfun(@(x) getfield(x, 'LatexName'), vals);
end

