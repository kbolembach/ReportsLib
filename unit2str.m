function out = unit2str(in)
%UNIT2STR Zmienia liczbę z jednostką na string. 

[data_in, units_in] = separateUnits(in);
if (string(data_in) == "1")
    num = "";
else
    num = PrintNum(data_in);
end
units = strip(symunit2str(units_in), 'left', '1');
out = append(num, units);

end

