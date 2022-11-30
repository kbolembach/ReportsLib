function out = PrintUnc(in, print_units)
%PRINTUNC Dla podanej liczby, zapisuje ją jak niepewność (dodaje zera jeśli
%to konieczne) i zwraca ją w formie stringa.
%print_units = 1 drukuje jednostki, = 0 nie drukuje (domyślnie = 0).
% Uwaga: funkcja NIE zaokrągla wartości! by to zrobić, należy skorzystać z
%funkcji roundMes.

if nargin == 1
   print_units = 0; 
end



if isstring(in)
    in = str2double(in);
end

if isa(in, 'sym')
   [in, units_in] = separateUnits(in);
   if in == floor(in)
       out = string(in);
   else
      in = vpa(in);
   end
end

if isa(in, 'Quantity')
    [in, units_in] = separateUnits(in.Uncertainty);
end

out = PrintNum(in);
test = strrep(out, "0", "");
test = strrep(test, ".", "");
if strlength(test) == 1 && str2double(test) ~= in
    if ~(floor(in) == in)
        out = append(out, "0");
    end
end

if order(in) == 0 && (floor(in) == in)
    out = append(out, ".0");
end

if exist('units_in', 'var') == 1 && out ~= "0" && print_units
    if units_in ~= sym(1)
        out = out.append(symunit2str(units_in));
    end
end

end

