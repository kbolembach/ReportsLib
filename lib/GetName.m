function out = GetName(vals)
%GETVALUE Dla tablicy [vals] zwraca pole 'Name' każdego jej elementu.

out = arrayfun(@(x) getfield(x, 'Name'), vals);
end

