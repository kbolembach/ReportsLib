function subbed_eq = SubstituteA(equation, sum, n)
%SUBSTITUTEA Dla danego równania niepewności typu A equation zapisanego w 
%formacie LaTeX podstawia:
%> sum - pod wyrażenie (xi - barx)^2;
%> n - ilość wykonanych pomiarów.

subbed_eq = convertStringsToChars(equation);
subbed_eq = regexprep(subbed_eq, '\\sum[^2]*2}', string(sum));
subbed_eq = regexprep(subbed_eq, '\(n-1\) \\cdot n', convertStringsToChars(string(n-1) + '\\cdot ' + string(n)));
    
end

