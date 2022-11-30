function obj = Constant(name, value, unit, latexname)
%CONSTANT - stała fizyczna
%	obj = Constant(name, value, latexname)
%
%   > name - nazwa stałej
%   > value - wartość stałej
%   * unit - jednostka (domyślnie 1)
%   * latexname - nazwa stałej w formacie LaTeX (opcjonalnie)

obj = Quantity;

obj.IsConstant = 1;
obj.Name = name;
obj.Value = value;

if nargin == 3
   obj.Unit = unit; 
elseif isa(value, 'sym')
    [~, target_unit] = separateUnits(value);
    obj.Unit = target_unit;
end

if nargin == 4
    obj.LatexName = latexname; 
else
    obj.LatexName = Latexify(name);
end

end 