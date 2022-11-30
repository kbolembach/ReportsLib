function out = str2unit(in)
%STR2UNIT Zamienia string na wartość z jednostką.

in = strrep(in, " ", "");
index = regexp(in, '[A-z]');
value = str2double(extractBetween(in, 1, index(1)-1));
units = str2symunit(extractBetween(in, index(1), strlength(in)));
out = value*units;

end

