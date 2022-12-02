function out = unit2latex(in)
%UNIT2LATEX Zmienia liczbę z jednostką na format LaTeX. 

[data_in, units_in] = separateUnits(in);
out = append(PrintNum(data_in), '\;', latex(units_in));
end

