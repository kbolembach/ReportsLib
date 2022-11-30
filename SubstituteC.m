function subbed_eq = SubstituteC(equation, args)
%SUBSTITUTEC Dla danego równania niepewności złożonej equation zapisanego w 
%formacie LaTeX podstawia pod zmienne określone w tablicy argnames ich wartości
%określone w tablicy args.

argnames = GetLatexName(args);
subbed_eq = convertStringsToChars(equation);
vals = GetValue(args, 1);
vals(vals == 0) = [];
uncs = GetUncertainty(args, 1);
uncs(uncs == 0) = [];
[ind1, ind2] = regexp(subbed_eq, 'u\([^\)]*\)');

for i=length(ind1):-1:1
    val = PrintUnc(uncs(i));
    if val ~= "0"
        % what_am_I_replacing = subbed_eq(ind1(i):ind2(i)); 
        % do debugowania
        subbed_eq = convertStringsToChars(subbed_eq(1:ind1(i) - 1) +  val + subbed_eq(ind2(i)+1:end));
    end
end

for i=length(vals):-1:1
    argname = Regexify(argnames(i));
    %[ind1, ind2] = regexp(subbed_eq, convertStringsToChars(append("(?<![\\||A-Za-z])" + argname + "(?!=[A-Za-z])")));
    for j=length(ind1):-1:1  
        subbed_eq = regexprep(subbed_eq, "(?<![\\||A-Za-z])" + argname + "(?!=[A-Za-z])", PrintUnc(vals(i)));
    end
end

subbed_eq = regexprep(subbed_eq, "\,", " \\cdot ");

end

