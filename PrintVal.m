function out = PrintVal(Value,Unc)
%PRINTVAL Dla podanej wielkości fizycznej drukuje jej wartość jako string,
%uwzględniając ilość zer przy zaokrągleniu zgodnie z niepewnością.
%Funkcja może przyjąć struct z wielkością fizyczną jako jedyny argument.
% Uwaga: funkcja NIE zaokrągla wartości! by to zrobić, należy skorzystać z
%funkcji roundMes.

if nargin == 1
    Unc = Value.Uncertainty;
    Value = Value.Value;
end

out = PrintNum(Value);
decimalPlaces = strfind(out, '.') - strlength(out);
if isempty(decimalPlaces)
    decimalPlaces = 0;
end

targetDecimalPlaces = LSBorder(Unc);
test = strrep(PrintNum(Unc), "0", "");
test = strrep(test, ".", "");
if strlength(test) == 1
    isUncSingleDigit = true;
else
    isUncSingleDigit = false;
end

if isUncSingleDigit
    targetDecimalPlaces = targetDecimalPlaces -1;
end

if decimalPlaces > targetDecimalPlaces
   if decimalPlaces == 0
      out = append(out, '.'); 
   end
   for i=decimalPlaces-1 :-1: targetDecimalPlaces
       out = append(out, '0');
   end
end
   
end
