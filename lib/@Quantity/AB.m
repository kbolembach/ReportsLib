function obj = AB(fn_name, index, arg_names, arg_vals, deltas, preferredUnit, output_type, latexname)
%QUANTITYB Wyznacza niepewność typu AB. Drukuje równanie niepewności typu
%AB oraz podstawia pod nie niepewności pomiarowe. Oblicza niepewność i 
%zaokrągla odpowiednio wartość.
%> fn_name - nazwa funkcji (string);
%> index - indeks wartości, którą liczymy (można zostawić "" jako pusty
%  indeks);
%> arg_names - tablica stringów zawierająca nazwy argumentów;
%> arg_vals - tablica wartości fizycznych;
%> deltas - wektor zawierający niepewności pomiarowe;
%* preferredUnit - preferowana jednostka;
%* output_type - określa, czy drukujemy równania w nastepujących trybach:
%   "single" - drukuje równania tylko raz, dla indeksu 1 bądź "";
%   "all" - drukuje wszystkie równania;
%   "none" - nie drukuje żadnego równania.
%  domyślna jest wartość "single".
%* latexname - nazwa wielkości w LaTeX. (opcjonalne)

%wymaga przetestowania

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

%jeżeli delta jest funkcją anonimową zamiast liczbą, użyj na niej wartości
%z poprzedniego pola:
if isa(deltas, 'function_handle') 
   delta_args = num2cell(arg_vals);
   deltas = deltas(delta_args{:});
end

% setup
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

symarr = str2sym(arg_names);

% obliczanie
obj.Uncertainty = UncAB(UncA(arg_vals), UncB(deltas)); %%% potencjalny problem - pamiętać by dla 
                                                %%% zmieniających się delt liczyć Quantity osobno.
unc_eq = PrintUncertaintyEquation("AB", [], str2sym(fn_name_unceq), symarr);
obj.Value = RoundMes(arg_vals, obj.Uncertainty);
if nargin >= 6
    obj = obj.CorelateUnits(preferredUnit);
end


% wyświetlanie
% if print_eq
%     disp("avg " + fn_name_index + " = " + PrintQuantity(mean(obj.Value), obj.Uncertainty, 1));
%     if numel(obj.Uncertainty) == 1
%         disp("u(" + fn_name_index + ") = " + PrintUnc(obj.Uncertainty, 1));
%         s = sum(obj.Value - mean(obj.Value).^2);
%         n = length(obj.Value);
%         ua = UncA(arg_vals);
%         ub = UncB(deltas);
%         approx = PrintNum(RoundMes(sqrt(mean(ua)^2 + mean(ub)^2), obj.Uncertainty, 1));
%         disp(SubstituteA(unc_eq, s, n) + " = " ...
%             + approx + " \approx " + PrintNum(obj.Uncertainty, 1));
%     end
%     disp(unc_eq);
% end

if print_eq
    if numel(obj.Value) == 1
        disp(fn_name_index + " = " + PrintQuantity(obj, obj.BaseUnit, 1));
        disp("val " + fn_name_index + " = " + PrintNum(obj.Value, print_units=1));
    end
    if numel(obj.Uncertainty) == 1
        disp("u(" + fn_name_index + ") = " + PrintUnc(obj, 1));
        %s = sum(obj.Value - mean(obj.Value).^2);
        %n = length(obj.Value);
        ua = UncA(arg_vals);
        ub = UncB(deltas);
        approx = RoundMes(sqrt(mean(ua)^2 + mean(ub)^2), obj.Uncertainty, 1);
        disp(SubstituteB(unc_eq, deltas) + " = " ...
             + PrintNum(RoundMes(approx, obj.Uncertainty, 1)) +...
             " \approx " + PrintNum(obj.Uncertainty, print_units=1));
    end
    disp(unc_eq);
    disp(' ');
end

end