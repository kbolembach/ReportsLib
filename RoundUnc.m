function [unc] = RoundUnc(var)
%ROUNDUNC zaokrągla liczbę zawsze w górę do dwóch cyfr znaczących.

if isa(var, 'sym')
    [var_val, var_units] = separateUnits(var);
    var_val = double(var_val);
    unc = zeros(length(var_val), 1);
    for i=1:length(var_val)
        rounded = round(var_val(i), 4, 'significant');
        if (nth_digit(rounded, 3) < 5)
            unc(i) = round(var_val(i), 2, 'significant') + 10^(order(rounded)-1);
        else
            unc(i) = round(var_val(i), 2, 'significant');
        end
    end
    unc = unc * var_units;
else
    unc = zeros(length(var), 1);
    for i=1:length(var)
        rounded = round(var(i), 4, 'significant');
        if (nth_digit(rounded, 3) < 5)
            unc(i) = round(var(i), 2, 'significant') + 10^(order(rounded)-1);
        else
            unc(i) = round(var(i), 2, 'significant');
        end
    end
end
