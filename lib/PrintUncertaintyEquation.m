function [eq] = PrintUncertaintyEquation(type, an_fn, fn_name, argsymlist, args, nvargs)
%PRINTUNCERTAINTYEQUATION Dla równania w postaci funkcji anonimowej an_fn i 
%o nazwie fn_name oraz zmiennych symbolicznych argsymlist i tablicy symboli 
%argsymlist, wypisuje równanie niepewności określonego typu "A", "B", "AB",
% lub "C". Funkcja zwraca string zawierający gotowe równanie w formacie LaTeX.

arguments
    type
    an_fn
    fn_name
    argsymlist
    args
    nvargs.self_uncertainty = 0
end

syms u;
str_fn_name = latex(sym(arrayfun(@string, fn_name)));

if type == "A"
    eq = append("u_a(", ...
        str_fn_name, ...
        ") = \sqrt{\frac{\sum^{n}_{i=1} (", ...
        str_fn_name, " - \overline{", ...
        str_fn_name,...
        "})^{2} }{(n-1) \cdot n}}");
end

if type == "B"
    sum = "";
    for i=1:length(argsymlist)
        arg = "\frac{\Delta_{" + arrayfun(@string, argsymlist(i)) + "} " + str_fn_name...
        + "^2}{3} + ";
        sum = sum + arg;
    end
    sum = extractBefore(sum, strlength(sum)-3);
    eq = append("u_{b}(", str_fn_name, ") = \sqrt{", sum, "}}");
end

if type == "AB"
    sum = "";
    for i=1:length(argsymlist)
        arg = "\frac{\Delta_{" + arrayfun(@string, argsymlist(i)) + "} " + str_fn_name...
        + "^2}{3} + ";
        sum = sum + arg;
    end
    sum = extractBefore(sum, strlength(sum)-3);
    
    eq = append("u_{ab}(", ...
        str_fn_name, ...
        ") = \sqrt{\frac{\sum^{n}_{i=1} (", ...
        str_fn_name, " - \overline{", ...
        str_fn_name,...
        "})^{2} }{(n-1) \cdot n} + ", sum, "}}");
end

if type == "C"
    sum = "";
    for i=1:length(argsymlist)
        arg = " u(" + GetLatexName(args(i)) + ")^2 ";
        if ~args(i).IsConstant 
            sum = sum + latex(diff(an_fn, argsymlist(i))^2) + " \cdot " + arg + " + ";
        end
    end
    sum = extractBefore(sum, strlength(sum)-3);
    if (nvargs.self_uncertainty ~= 0)
        sum = sum + " + (" + latex(nvargs.self_uncertainty) + " \cdot " + str_fn_name + ")^2";
    end
    eq = append("u_{c}(", str_fn_name, ") = \sqrt{", sum, "}");
end
end

