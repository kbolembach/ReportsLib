function subbed_eq = SubstituteB(equation, deltas)
%SUBSTITUTEB Dla danego równania niepewności typu B equation zapisanego w 
%formacie LaTeX podstawia wartości w wektorze deltas pod dokładności
%pomiarowe we wzorze.

subbed_eq = convertStringsToChars(equation);
[ind1, ind2] = regexp(equation, '\\frac{\s*\\Delta[^^2]*\^2');
for i=length(ind1):-1:1
    subbed_eq = convertStringsToChars(subbed_eq(1:ind1(i) - 1) + "\frac{" +  PrintNum(deltas(i)) + "^2" + subbed_eq(ind2(i)+1:end));
end

end

