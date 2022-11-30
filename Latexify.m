function out = Latexify(in)
%LATEXIFY Na podstawie stringa (np. nazwy zmiennej) in zwraca jego "latexową" wersję.

out = string(latex(str2sym(in)));
    
end
