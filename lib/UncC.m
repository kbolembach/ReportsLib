function [unc] = UncC(an_fn, sym_xj, xj, mode)
%UNCC Wyznacza niepewność złożoną funkcji anonimowej an_fn ze zmiennymi
%symbolicznymi sym_xj i wielkościami Quantity xj.
%Sprecyzuj mode == "exact" by uzyskać niezaokrąglony wynik.
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

