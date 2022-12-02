function subbed_eq = Substitute(equation, args)
%SUBSTITUTE Dla ogólnego równania equation zapisanego w formacie LaTeX 
%podstawia, korzystając z tablicy Quantity args, za nazwy zmiennych ich
%wartości numeryczne.

argnames = GetLatexName(args);
subbed_eq = convertStringsToChars(equation);
vals = setdiff(GetValue(args, 0), 0, 'stable');

for i=length(vals):-1:1
    [ind1, ind2] = regexp(subbed_eq, convertStringsToChars(append("(?<![\\||A-Za-z])" + Regexify(argnames(i)) + "(?!=[A-Za-z])")));
    for j=length(ind1):-1:1  
        subbed_eq = convertStringsToChars(subbed_eq(1:ind1(j) - 1) + PrintNum(vals(i)) + subbed_eq(ind2(j)+1:end));
    end
end

subbed_eq = regexprep(subbed_eq, "\,", " \\cdot ");

end

