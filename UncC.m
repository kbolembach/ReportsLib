function [unc] = UncC(an_fn, sym_xj, xj, mode)
%UNCC Wyznacza niepewność złożoną funkcji F ze zmiennymi sym_xj
%następnie podstawia pod te zmienne xj.Value oraz używa także niepewności 
%tych zmiennych xj.Uncertainty.
%Ewentualnie dla u_xj == "exact" by uzyskać niezaokrąglony wynik.
if nargin == 3 || mode == "exact"
    sum = 0;
    pd = pdArr(an_fn, sym_xj);
    vals = GetValue(xj);
    for j = 1:length(pd)
        if xj(j).IsConstant == 0
            sum = sum + (feval(pd{j}, vals) .* mean(xj(j).Uncertainty) ).^2;
            if isa(sum, 'sym')
                sum = simplify(sum); 
            end
        end
    end
    if nargin == 4
        if mode == "exact"
            unc = sqrt(sum);
        end
    else
        
        unc = RoundUnc(sqrt(sum));
    end
    
end

end

