function var = RoundMes(x, ux, print_mode)
%ROUNDMES - zaokrągla wynik pomiaru x do rzędu drugiej cyfry niepewności ux
%Dla dodatkowego argumentu print_mode = 1 zaokrągla pomiar do czterech cyfr

if isa(x, 'sym')
    [x_val, x_units] = separateUnits(x);
    if isa(x_val, 'sym')
        x_val = double(x_val);
    end
    [ux_val, ~] = separateUnits(ux);
    if isa(ux_val, 'sym')
        ux_val = double(ux_val);
    end
    if nargin == 2
        var = zeros(length(x_val), 1);
        if (length(x_val) == length(ux_val))
            for i=1:length(x_val)
                var(i) = round(x_val(i)* 10^(-LSBorder(ux_val(i))))  /10^(-LSBorder(ux_val(i)));
            end
        else
            for i=1:length(x_val)
                var(i) = round(x_val(i)* 10^(-LSBorder(ux_val(1))))  /10^(-LSBorder(ux_val(1)));
            end
        end
    elseif nargin == 3
        if print_mode == 1
            var = zeros(length(x_val), 1);
            if (length(x_val) == length(ux_val))
                for i=1:length(x_val)
                    var(i) = round(x_val(i)* 10^(-order(ux_val(i)/1000)))  /10^(-order(ux_val(i)/1000));
                end
            else
                for i=1:length(x_val)
                    var(i) = round(x_val(i)* 10^(-order(ux_val(1)/1000)))  /10^(-order(ux_val(1)/1000));
                end
            end
        end
    end
    var = var .* x_units;
else
    if nargin == 2
        var = zeros(length(x), 1);
        if (length(x) == length(ux))
            for i=1:length(x)
                var(i) = round(x(i)* 10^(-LSBorder(ux(i))))  /10^(-LSBorder(ux(i)));
            end
        else
            for i=1:length(x)
                var(i) = round(x(i)* 10^(-LSBorder(ux(1))))  /10^(-LSBorder(ux(1)));
            end
        end
    elseif nargin == 3
        if print_mode == 1
            var = zeros(length(x), 1);
            if (length(x) == length(ux))
                for i=1:length(x)
                    var(i) = round(x(i)* 10^(-order(ux(i)/1000)))  /10^(-order(ux(i)/1000));
                end
            else
                for i=1:length(x)
                    var(i) = round(x(i)* 10^(-order(ux(1)/1000)))  /10^(-order(ux(1)/1000));
                end
            end
        end
    end
end
end