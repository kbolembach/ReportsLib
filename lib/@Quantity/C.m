function obj = C(an_fn, fn_name, args, nvargs)
%C Na podstawie anonimowej funkcji an_fn wyznacza niepewność
%złożoną (typu C). Drukuje równanie an_fn, równanie niepewności złożonej
%oraz podstawia pod nich podane dane. 
%> an_fn - funkcja anonimowa;
%> fn_name - nazwa funkcji (string);
%> args - tablica wartości fizycznych;
%> nvargs.preferred_unit - preferowana jednostka;
%* nvargs.index - indeks wartości, którą liczymy (można zostawić "" jako pusty
%  indeks);
%* nvargs.output - określa, czy drukujemy równania w nastepujących trybach:
%   "single" - drukuje równania tylko raz, dla indeksu 1 bądź "";
%   "all" - drukuje wszystkie równania;
%   "none" - nie drukuje żadnego równania.
%  domyślna jest wartość "single".
%* nvargs.latexname - nazwa wielkości w LaTeX. (opcjonalne)

arguments
    an_fn
    fn_name
    args
    nvargs.self_uncertainty = sym(0)   
    nvargs.preferred_unit = 1
    nvargs.index = ""
    nvargs.output = "single"
    nvargs.latex_name
end

obj = Quantity;
obj.Name = fn_name;

if ~isa(nvargs.self_uncertainty, 'sym')
   nvargs.self_uncertainty = sym(nvargs.self_uncertainty); 
end

if exist('nvargs.latexname', 'var')
    obj.LatexName = nvargs.latexname;
else
    obj.LatexName = Latexify(fn_name);
end

obj.Unit = nvargs.preferred_unit;


% setup
print_eq = nvargs.output == "all" || (nvargs.output == "single" && string(nvargs.index) == "1") ...
    || string(nvargs.index) == "";

if string(nvargs.index) ~= ""
    fn_name_index = Latexify(fn_name + "_" + string(nvargs.index));
else
    fn_name_index = Latexify(fn_name);
end

fn_name_unceq = fn_name;
if nvargs.output == "all"
    fn_name_unceq = fn_name + string(nvargs.index);
elseif endsWith(fn_name_unceq, "_")
    fn_name_unceq = extractBefore(fn_name_unceq, strlength(fn_name_unceq));
end

%
args_from_anfn = @(f)strsplit(regexp(func2str(f), '(?<=^@\()[^\)]*', 'match', 'once'), ',');
symarr = sym(args_from_anfn(an_fn));
%
unc_eq = PrintUncertaintyEquation("C", an_fn, str2sym(fn_name_unceq), symarr, args, self_uncertainty = nvargs.self_uncertainty);

% obliczanie
arg_vals_cell = num2cell(GetValue(args));
try 
    orig_units_value = unitConvert(simplify(  an_fn(arg_vals_cell{:})  ), nvargs.preferred_unit);
catch
    orig_units_value = an_fn(arg_vals_cell{:});
end
try   
    orig_units_unc = unitConvert(UncC(an_fn, symarr, args, "exact"), sym(nvargs.preferred_unit));
catch
    orig_units_unc = UncC(an_fn, symarr, args, "exact");
end
if (nvargs.self_uncertainty)
    obj.Uncertainty = RoundUnc( sqrt( orig_units_unc^2 + (orig_units_value * double(nvargs.self_uncertainty))^2) );
    orig_units_unc = RoundUnc(orig_units_unc);
else
    orig_units_unc = RoundUnc(orig_units_unc);
    obj.Uncertainty = orig_units_unc;
end
obj.Value = RoundMes(orig_units_value, obj.Uncertainty);

% wyświetlanie
if print_eq
    % 1 - wartość = x.xx(yy) U
    % 2 - niepewność = xx U
    % 3 - podstawienie do wzoru
    % 4 - podstawienie do wzoru na niepewność
    % 5 - wzór
    % 6 - wzór na niepewność
    
    if numel(obj.Value) == 1
        % 1
        disp(fn_name_index + " = " + obj.Print());
    end
    
    if numel(obj.Uncertainty) == 1
        % 2
        disp("u(" + fn_name_index + ") = " + PrintUnc(obj, 1));
    end
        
    if numel(obj.Value) == 1
        disp('Podstawienie: ');
        % 3
        disp(Substitute(latex(sym(fn_name) == an_fn), args) + ... 
            " \approx " + PrintNum(orig_units_value, sig_figures=5) + ...
            " = " + PrintNum(RoundMes(orig_units_value, orig_units_unc)));
    end
    
    if numel(obj.Uncertainty) == 1
        approx = 0;        pd = pdArr(an_fn, symarr);
        vals = GetValue(args);
        for j = 1:length(pd)
            if args(j).IsConstant == 0
            approx = approx + (feval(pd{j}, vals) .* args(j).Uncertainty ).^2;
            end
        end
        try
            approx = unitConvert(simplify(approx), nvargs.preferred_unit); 
        catch
        end
        
        % 4
        disp(SubstituteC(unc_eq, args) + " = " ...
            + PrintNum(RoundMes(sqrt(approx), orig_units_unc, 1)) + " \approx " +...
            PrintNum(orig_units_unc, print_units=1) );
        
    end
    
    disp('Wzory: ');
    % 5
    disp(latex(fn_name_unceq == sym(an_fn)));
    % 6
    disp(unc_eq);
    disp(' ');
end


%zamiana jednostek, drukowanie
if (double(separateUnits(obj.Value)))~=0
    [~, old_units] = separateUnits(obj.Value);
    if exist('nvargs.preferred_unit', 'var')
    if old_units ~= nvargs.preferred_unit
        obj = obj.CorelateUnits(nvargs.preferred_unit);
        if print_eq
            disp('Po zamianie jednostek: ');
            disp(fn_name_index + " = " + obj.Print()); % 1
            disp("u(" + fn_name_index + ") = " + PrintNum(obj.Uncertainty, print_units=1)); % 4
            disp(' ');
        end
    end
    end

end



end


