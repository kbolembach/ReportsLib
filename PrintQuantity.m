function out = PrintQuantity(Quantity, target_unit, print_units)
%PRINTQUANTITY (OBSOLETE! USE METHOD QUANTITY.PRINT) Drukuje wartość 
%i niepewność wielkości fizycznej.
%   out = PrintQuantity(Value, Unc, print_units)
%   
%Funkcja może przyjąć struct z wielkością fizyczną jako jedyny argument.
%print_units = 1 drukuje jednostki, = 0 nie drukuje (domyślnie = 0).

if nargin < 3
    print_units = 0;
end

if nargin < 2
   target_unit = Quantity(1).BaseUnit; 
end

% if nargin >= 2  
%     if isa(Value, 'Quantity')
%         Unc = GetUncertainty(Value);
%         Value = GetValue(Value);     
%     end
%     [~, units] = separateUnits(Value);
%     
%     if isa(Value, 'sym') && isa(Unc, 'sym')
%         unc_ = RoundUnc(double(separateUnits(Unc)));
%         val_ = RoundMes(double(separateUnits(Value)), unc_);
%         Value = PrintVal(val_, unc_);
%         Unc = PrintUnc(unc_);
%     end
%     
%     if strfind(Unc, '.') == 2
%        Unc = strrep(Unc, '.', ''); 
%     end
%     out = string(Value) + "(" + ...
%         extractBetween(string(Unc), strlength(string(Unc))-1, strlength(string(Unc))) + ")";
%     if print_units
%         out = out.append(unit2str(units));
%     end
% end

for i=length(Quantity):-1:1
Unit(i) = Quantity(i).Unit;
Conversion = unitConversionFactor(Quantity(i).BaseUnit, target_unit);
Unc_num(i) = round(GetUncertainty(Quantity(i), 1) .* Conversion, 2, 'significant');
Value_num(i) = RoundMes(GetValue(Quantity(i), 1) .* Conversion, Unc_num(i));
Value(i) = PrintVal(Value_num(i), Unc_num(i));
Unc(i) = PrintUnc(Unc_num(i));

if strfind(Unc(i), '.') == 2
   Unc(i) = strrep(Unc(i), '.', ''); 
end

out(i) = Value(i) + "(" + ...
    extractBetween(Unc(i), strlength(Unc(i))-1, strlength(Unc(i))) + ")";

if print_units
    out(i) = append(out(i), unit2str(target_unit));
end

end


% 
% if strfind(Unc, '.') == 2
%    Unc = strrep(Unc, '.', ''); 
% end
% out = string(Value) + "(" + ...
%     extractBetween(string(Unc), strlength(string(Unc))-1, strlength(string(Unc))) + ")";
% if print_units
%     out = arrayfun(@(o, u) append(o, u), out, unit2str(Unit));
% end

end

