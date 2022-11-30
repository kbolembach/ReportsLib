function Q = QuantityAB(fn_name, index, arg_names, arg_vals, deltas, output_type)
%QUANTITYB Wyznacza niepewność typu AB. Drukuje równanie niepewności typu
%AB oraz podstawia pod nie niepewności pomiarowe. Oblicza niepewność i 
%zaokrągla odpowiednio wartość.
%> fn_name - nazwa funkcji (string);
%> index - indeks wartości, którą liczymy (można zostawić "" jako pusty
%  indeks);
%> arg_names - tablica stringów zawierająca nazwy argumentów;
%> arg_vals - tablica wartości fizycznych;
%> deltas - wektor zawierający niepewności pomiarowe;
%> output_type - określa, czy drukujemy równania w nastepujących trybach:
%   "single" - drukuje równania tylko raz, dla indeksu 1 bądź "";
%   "all" - drukuje wszystkie równania;
%   "none" - nie drukuje żadnego równania.
%  domyślna jest wartość "single".

% setup
if nargin < 6
    output_type = "single"; 
end
print_eq = output_type == "all" || (output_type == "single" && string(index) == "1");
fn_name_index = fn_name + string(index);
fn_name_unceq = fn_name;

if output_type == "all"
    fn_name_unceq = fn_name + string(index);
elseif endsWith(fn_name_unceq, "_")
    fn_name_unceq = extractBefore(fn_name_unceq, strlength(fn_name_unceq));
end
symarr = str2sym(arg_names);
% obliczanie
Q.unc = uncAB(uncA(arg_vals), uncB(deltas)); %%%%%%%% potencjalny problem - pamiętać by dla zmieniających się delt liczyć Quantity osobno.
uncEq = printUncEq("AB", [], str2sym(fn_name_unceq), symarr);
Q.val = roundMes(arg_vals, Q.unc);
Q.avg.unc = roundUnc(mean(Q.unc));
Q.avg.val = roundMes(mean(Q.val), Q.avg.unc);
Q.avg.const = 0;
% wyświetlanie
disp("średnia " + fn_name_index + " = " + mean(Q.val)); 
if numel(Q.unc) == 1
    disp("u_{ab}(" + fn_name_index + ") = " + string(round(vpa(Q.unc), 2, 'significant')));
    if print_eq
        s = sum((Q.val - mean(Q.val)).^2);
        n = length(Q.val);
        ua = uncA(arg_vals);
        ub = uncB(deltas);
        approx = vpa(sqrt(mean(ua)^2 + mean(ub)^2));
        disp(SubstituteAB(uncEq,deltas,s,n) + " = " ...
            + string(round(approx,4, 'significant')) + " \approx " + PrintUnc(round(vpa(Q.unc), 2, 'significant')) );
    end
end
if print_eq
    disp(uncEq);
end


Q.const = false;
disp(' ');
end