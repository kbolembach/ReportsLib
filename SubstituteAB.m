function subbed_eq = SubstituteAB(equation, deltas, sum, n)
%SUBSTITUTEAB Dla danego równania niepewności typu AB equation zapisanego w 
%formacie LaTeX podstawia pod zmienne:
%> deltas - dokładności pomiarowe;
%> sum - wartość sumy (xi - barx)^2;
%> n - ilość wykonanych pomiarów.

subbed_eq = convertStringsToChars(equation);
[ind1, ind2] = regexp(subbed_eq, '\\frac{\s*\\Delta[^^2]*\^2');
for i=length(ind1):-1:1
    subbed_eq = convertStringsToChars(subbed_eq(1:ind1(i) - 1) + "\frac{" + PrintNum(deltas(i)) + "^2" + subbed_eq(ind2(i)+1:end));
end

subbed_eq = regexprep(subbed_eq, '\\sum[^2]*2}', string(sum));
subbed_eq = regexprep(subbed_eq, '\(n-1\) \\cdot n', convertStringsToChars(string(n-1) + '\\cdot ' + string(n)));
    
end

