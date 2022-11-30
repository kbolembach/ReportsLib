function out = PrintNum(input, nvargs)
%PRINTNUM Zwraca liczbę jako sformatowany string.
%print_units=1 drukuje jednostki, = 0 nie drukuje (domyślnie = 0).
%decimals=n drukuje przynajmniej do rzędu 10^-n, n>0, opcjonalne
%sig_figures=n drukuje n cyfr znaczących , opcjonalne
%sig_figures powinno być mniejsze bądź równe od decimals, ale są niezależne 
%od siebie
%rounding_order= rząd zaokrąglenia

arguments
   input
   nvargs.print_units = 0
   nvargs.decimals = 0
   nvargs.sig_figures = 0
   nvargs.rounding_order = -14
end

if isstring(input)
    input = str2double(input);
end

if isa(input, 'sym')
   [input, units_input] = separateUnits(input);
   if input == floor(input)
       out = string(input); % więcej warunków wymagane
   else
      input = double(input);
   end
end

if ~exist('out', 'var')
    %przypadek wystarczająco krótkiej liczby
    if ~contains(string(input), 'e')
        
        out = round(input, -LSBorder(input)+1);

        if (nvargs.sig_figures ~= 0)
        	out = round(input, nvargs.sig_figures, 'significant');
        end    
        
        if (nvargs.decimals ~= 0)
           out = round(out, nvargs.decimals); 
        end
        out = string(out);
        
        if (contains(out, '.'))
           number_of_decimals = strlength(extractBetween(out, strfind(out, ".")+1, strlength(out))); 
        else
            number_of_decimals = 0;
        end
        
        
        if (number_of_decimals < nvargs.decimals)
            if (~contains(out, '.'))
                out = out.append(".");
            end
            for i=1:1:(nvargs.decimals - number_of_decimals)
                out = out.append("0");
            end
        end
        
        number_of_digits = strlength(strrep(out, '.', ''));
        if (number_of_digits < nvargs.sig_figures)
            if (~contains(out, '.'))
                out = out.append(".");
            end
            for i=1:1:(nvargs.sig_figures - number_of_digits)
                out = out.append("0");
            end
        end
            
        % dla np. 182.96256104177971 sig_figures=4 nie uwzględnia .0
        
        
        
        
    else %gdy liczba zapisana jest np. 4e-19
        out = string(input);
        mantissa = extractBetween(out, 1, strfind(out, "e")-1);
        if (contains(mantissa, '.'))
           mantissa_order = strlength(extractBetween(mantissa, 1, strfind(mantissa, '.')-1));
        else
           mantissa_order = strlength(mantissa); 
        end
        mantissa_length = strlength(mantissa) - 1;
        mantissa = strrep(mantissa, '.', '');
        exponent = str2double(extractBetween(out, strfind(out,"e")+1, strlength(out)))...
                    + mantissa_order;

        magnitude = exponent - mantissa_length + 1;

        if (nvargs.sig_figures ~= 0)
            mantissa = round(str2double(mantissa), nvargs.sig_figures, 'significant');
            mantissa = strip(string(mantissa), "0"); 
        end            

        if (nvargs.decimals ~= 0)
           if (isa(mantissa, 'string'))
            mantissa = str2double(mantissa);
           end
           mantissa = mantissa * 10^(magnitude + nvargs.decimals);
           mantissa = round(mantissa); 
        end
        if (isa(mantissa, 'double'))
            mantissa = string(mantissa);
        end

        if (mantissa ~= "0")
            out = "0.";

            for i=1:1:-exponent
                out = append(out, "0");
            end
            out = append(out, mantissa);
        else
            out = "0";
        end

    end
end

if exist('units_in', 'var') == 1 && out ~= "0" && nvargs.print_units
    if units_input ~= sym(1)
        out = out.append(symunit2str(units_input));
    end
end


end

