function quantity = Scale(quantity, scale_factor)
%SCALE Funkcja przydatna do przeskalowania wielkości fizycznej o pewną
%wielkość - mnoży wartośc i niepewność razy scale_factor. Przydatne w
%konwersji jednostek.
for i=length(quantity):-1:1 
    quantity(i).Value = quantity(i).Value .* scale_factor;
    quantity(i).Uncertainty = quantity(i).Uncertainty .* scale_factor;
end
end

