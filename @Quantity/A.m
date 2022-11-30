function obj = A(fn_name, index, arg_vals, preferredUnit, output_type, latexname)
%A Wyznacza niepewność typu A. Drukuje równanie niepewności typu A oraz
%podstawia pod nie wartości (nazwa funkcji to równocześnie nazwa zmiennej).
%Oblicza niepewność i zaokrągla odpowiednio wartość.
%> fn_name - nazwa funkcji (string);
%> index - indeks wartości, którą liczymy (można zostawić "" jako pusty
%  indeks);
%> arg_vals - tablica wartości fizycznych;
%* preferredUnit - preferowana jednostka;
%* output_type - określa, czy drukujemy równania w nastepujących trybach:
%   "single" - drukuje równania tylko raz, dla indeksu 1 bądź "";
%   "all" - drukuje wszystkie równania;
%   "none" - nie drukuje żadnego równania.
%  domyślna jest wartość "single".
%* latexname - nazwa wielkości w LaTeX. (opcjonalne)

% wymaga przetestowania, i na pewno przepisania...

%parsowanie argumentów
obj = Quantity;
obj.Name = fn_name;
if exist('latexname', 'var')
    obj.LatexName = latexname;
else
    obj.LatexName = Latexify(fn_name);
end

if ~exist('output_type', 'var')
    output_type = "single"; 
end

%setup
print_eq = output_type == "all" || (output_type == "single" && string(index) == "1") ...
    || string(index) == "";

if string(index) ~= "" && ~(output_type == "single" && string(index) == "1")
    fn_name_index = Latexify(fn_name + "_" + string(index));
else
    fn_name_index = Latexify(fn_name);
end

fn_name_unceq = fn_name;
if output_type == "all"
    fn_name_unceq = fn_name + string(index);
elseif endsWith(fn_name_unceq, "_")
    fn_name_unceq = extractBefore(fn_name_unceq, strlength(fn_name_unceq));
end

%obliczanie
obj.Uncertainty = UncA(arg_vals);
obj.Value = RoundMes(arg_vals, obj.Uncertainty);
unc_eq = PrintUncertaintyEquation("A", [], str2sym(fn_name_unceq));
if exist('preferredUnit', 'var')
    obj = obj.CorelateUnits(preferredUnit);
end

%wyświetlanie
if print_eq
    disp("avg " + fn_name_index + " = " + PrintQuantity(mean(obj.Value), obj.Uncertainty, 1));
    if numel(obj.Uncertainty) == 1
        disp("u(" + fn_name_index + ") = " + PrintUnc(obj.Uncertainty, 1));
        s = sum(obj.Value - mean(obj.Value).^2);
        n = length(obj.Value);
        disp(SubstituteA(unc_eq, s, n) + " = " ...
            + PrintNum(RoundMes(std(obj.Value) * sqrt(n), obj.Uncertainty, 1)) + ...
            " \approx " + PrintNum(obj.Uncertainty, print_units=1));
    end
    disp(unc_eq);
end

disp(' ');

end