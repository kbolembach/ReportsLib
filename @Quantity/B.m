function obj = B(fn_name, arg_names, arg_vals, deltas, nvargs)
%function obj = B(fn_name, index, arg_names, arg_vals, deltas, preferredUnit, nvargs.output, latexname)
%B Wyznacza niepewność typu B. Drukuje równanie niepewności typu B
%oraz podstawia pod nie niepewności pomiarowe. Oblicza niepewność i zaokrągla
%odpowiednio wartość.
%   obj = B(fn_name, arg_names, arg_vals, deltas, ...
%           index, preferredUnit, nvargs.output, latexname)
%> fn_name - nazwa funkcji (string);
%> arg_names - tablica stringów zawierająca nazwy argumentów;
%> arg_vals - tablica wartości fizycznych;
%> deltas - wektor zawierający niepewności pomiarowe (albo funkcja anonimowa, która przyjmie wartości z pola arg_vals);
%** Opcjonalne:
%* preferredUnit - preferowana jednostka;
%* index - indeks wartości, którą liczymy (można zostawić "" jako pusty
%  indeks);
%* nvargs.output - określa, czy drukujemy równania w nastepujących trybach:
%   "single" - drukuje równania tylko raz, dla indeksu 1 bądź "";
%   "all" - drukuje wszystkie równania;
%   "none" - nie drukuje żadnego równania.
%  domyślna jest wartość "single".     
%* latexname - nazwa funkcji w formacie LaTeX

%parsowanie argumentów

arguments
    fn_name
    arg_names
    arg_vals
    deltas  
    nvargs.preferred_unit = 1
    nvargs.index = ""
    nvargs.output = "single"
    nvargs.latex_name
end

if exist('nvargs.latexname', 'var')
    obj.LatexName = nvargs.latexname;
else
    obj.LatexName = Latexify(fn_name);
end

obj.Unit = nvargs.preferred_unit; %#ok<*STRNU>
obj = Quantity;
obj.Name = fn_name;

% setup
print_eq = nvargs.output == "all" || (nvargs.output == "single" && string(nvargs.index) == "1") ...
    || string(nvargs.index) == "";

if string(nvargs.index) ~= "" && ~(nvargs.output == "single" && string(nvargs.index) == "1")
    fn_name_index = Latexify(fn_name + "_" + string(nvargs.index));
else
    fn_name_index = Latexify(fn_name);
end

%formatowanie nazwy funkcji
fn_name_unceq = fn_name;
if nvargs.output == "all"
    fn_name_unceq = fn_name + string(nvargs.index);
elseif endsWith(fn_name_unceq, "_")
    fn_name_unceq = extractBefore(fn_name_unceq, strlength(fn_name_unceq));
end

%tablica z symbolicznymi nazwami zmiennych
symarr = str2sym(arg_names);

%jeżeli delta jest funkcją anonimową zamiast liczbą, użyj na niej wartości
%z poprzedniego pola:
if isa(deltas, 'function_handle') 
   delta_args = num2cell(arg_vals);
   deltas = deltas(delta_args{:});
end


% obliczanie
if numel(arg_vals) == 1
    obj.Uncertainty = sym(UncB(deltas, arg_vals));
else
    obj.Uncertainty = sym(UncBarr(deltas, arg_vals));
end
unc_eq = PrintUncertaintyEquation("B", [], str2sym(fn_name_unceq), symarr, []);
obj.Value = sym(RoundMes(arg_vals, obj.Uncertainty));

% wyświetlanie
if print_eq
    if numel(obj.Value) == 1
        disp(fn_name_index + " = " + obj.Print());
        disp("val " + fn_name_index + " = " + PrintNum(obj.Value, print_units=1));
    end
    if numel(obj.Uncertainty) == 1
        disp("u(" + fn_name_index + ") = " + PrintUnc(obj, 1));
        approx = vpa(sqrt(sum( ((deltas).^2) ./ 3)));
        disp(SubstituteB(unc_eq, deltas) + " = " ...
             + PrintNum(RoundMes(approx, obj.Uncertainty, 1)) +...
             " \approx " + PrintNum(obj.Uncertainty, print_units=1));
    end
    disp(unc_eq);
    disp(' ');
end

end