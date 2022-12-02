classdef Quantity
    %QUANTITY Klasa przechowująca wartości fizyczne.
    %Pola:
    %> Name
    %> Value
    %> Unit
    %> Uncertainty
    %> LatexName
    %> IsConstant
    
    properties
        Name {mustBeValidVariableName} = "x"
        Value = sym(0);
        Unit = sym(1);
        Uncertainty = 0;
        LatexName = ""
        IsConstant {mustBeMember(IsConstant, [0, 1])} = 0;
    end
    
    methods
        function obj = Quantity(name, value, preferredUnit, ...
                uncertainty, latexname, isconstant)
            %QUANTITY Konstruktor klasy Quantity.
            %> name - nazwa wielkości;
            %> value - (symbolic) wartość wielkości;
            %> preferredUnit - (symbolic) preferowana jednostka (domyślnie 1);
            %> uncertainty - (symbolic) niepewność;
            %* latexname - string zawierający reprezentacje nazwy wielkości
            %  w LaTeX;
            %* isconstant - 1 dla stałej fizycznej, 0 w innym przypadku;
            %By zainicjalizować stałą, wystarczy podać pierwsze dwa
            %argumenty. Dla wielkości fizycznej wystarczy pierwsze cztery
            %argumenty, pozostałe są opcjonalne.
            if nargin >=2
                obj.Name = name;
                obj.Value = sym(value);
                obj.IsConstant = 1;
            end
            if nargin >=3
                obj.Unit = sym(preferredUnit);
            end
            if nargin >= 4
               obj.IsConstant = 0;
               obj.Uncertainty = sym(uncertainty);
            end
            if exist('latexname', 'var')
                obj.LatexName = latexname;
            else
                if nargin ~= 0
                    obj.LatexName = Latexify(name); 
                end
            end
            if exist('isconstant', 'var')
                obj.IsConstant = isconstant;
            end
            
        end
        
        function obj = RemoveUnits(obj)
           %REMOVEUNITS Usuwa jednostki z danej wielkości.
           obj.Unit = sym(1);
           obj.Value = separateUnits(obj.Value);
           obj.Uncertainty = separateUnits(obj.Uncertainty);
        end
        
        function obj = ChangeUnit(obj, target_unit)
            %CHANGEUNIT Zmienia jednostkę na target_unit.
           if obj.Unit == 1
               obj.Value = obj.Value * target_unit;
               obj.Uncertainty = obj.Uncertainty * target_unit;
           else
               c = unitConversionFactor(obj.Unit, target_unit);
               obj.Unit = target_unit;
               obj.Value = separateUnits(obj.Value) * c * target_unit;
               obj.Uncertainty = separateUnits(obj.Uncertainty) * c * target_unit;
           end
        end    
        
        function obj = CorelateUnits(obj, target_unit)
            %CORELATEUNITS Koreluje jednostki pól Value i Uncertainty ze
            %sobą do target_unit.
            [unc, units_unc] = separateUnits(unitConvert(obj.Uncertainty, target_unit));
            obj.Uncertainty = round(unc, 2, 'significant') * units_unc;
            obj.Value = RoundMes(unitConvert(obj.Value, target_unit), obj.Uncertainty);
        end
        
        function out = BaseUnit(obj)
            %BASEUNIT Zwraca 'podstawową' jednostkę bez prefiksu. UWAGA! 
            % Zwraca gramy zamiast kilogramów. Przy bardziej skomplikowanych 
            % jednostkach funkcja nie działa poprawnie. 
           if obj.Unit == sym(1)
               out = sym(1);
           else
                u = symunit; %#ok<NASGU>
               prefixes = ["Y", "Z", "E", "P", "T", "G", "M", "k", "h", "da", ...
                   "", "d", "c", "mc", "m", "n", "p", "f", "a", "z", "y"];
               unit = unit2str(obj.Unit);
               for i=1:length(prefixes)
                  if startsWith(unit, prefixes(i)) && unit ~= "T" %% nie zapominajmy o Teslach 
                     base_unit = extractAfter(unit, strlength(prefixes(i)));
                      if isUnit(str2sym(append('u.', base_unit)))
                          out = str2symunit(base_unit);
                         break 
                      end
                  else
                      out = obj.Unit;
                  end
               end
           end
        end
        
        function [value, uncertainty, unit] = Decompose(obj, units)
            arguments
               obj Quantity
               units = 1
            end
            %DECOMPOSE Rozkłada Quantity na wartości value, uncertainity oraz jednostkę unit.
            %Ustaw units = 0 żeby otrzymać wartości bez jednostek. 
            if units
                value = obj.Value;
                uncertainty = obj.Uncertainty;
                unit = obj.Unit;
            else
                [value, ~] = separateUnits(obj.Value);
                [uncertainty, ~] = separateUnits(obj.Uncertainty);
                unit = obj.Unit;
            end
        end
        
        function out = Average(objs)
           %AVERAGE Bierze średnią z wartości i niepewności obiektów objs Quantity. 
           %Średnia niepewność jest liczona jako prosta średnia arytmetyczna.
           %Wartości są automatycznie zaokrąglone.
           out.Uncertainty = round(mean(GetValue(objs)), 2, 'significant');
           out.Value = RoundMes(mean(GetValue(objs)), out.Uncertainty);
           out.Name = objs(1).Name;
           out.Unit = objs(1).Unit;
           out.IsConstant = 0;
           out.LatexName = objs(1).LatexName;
        end
        
        function out = Print(objs, nvargs)
            %PRINT Drukuje Quantity jako string. Nowsza wersja
            %PrintQuantity. Opcjonalny argument print_units = 1 by drukować
            %także jednostkę.
            arguments
                objs
                nvargs.print_units = 0
            end
            
            for i=length(objs):-1:1
                [target_value, target_unit] = separateUnits(objs(i).Value);
                [target_unc, ~] = separateUnits(objs(i).Uncertainty);
                val = PrintVal(target_value, target_unc);
                unc = PrintUnc(target_unc);

                if strfind(unc, '.') == 2
                   unc = strrep(unc, '.', ''); 
                end

                out(i) = val + "(" + ...
                    extractBetween(unc, strlength(unc)-1, strlength(unc)) + ")";

                if nvargs.print_units 
                    out(i) = append(out(i), unit2str(target_unit));
                end

            end
        end
        
        %Overloadowanie operatorów:
        % a + b, gdzie a, b to Quantity
        % a - b, gdzie a, b to Quantity
        % a .* b, gdzie a, b to Quantity, double lub sym
        % a ./ b, gdzie a, b to Quantity, double lub sym
        % -a (a to Quantity) odwraca wartość a.Value na -a.Value
        
        % a + b
%         function out = plus(obj1, obj2)
%            arguments
%                obj1 Quantity
%                obj2 Quantity 
%            end
%            out = obj1;
%            out.IsConstant = max(out.IsConstant, obj2.IsConstant);
%            out.Value = out.Value + obj2.Value;
%            out.Uncertainty = sqrt( out.Uncertainty^2 + obj2.Uncertainty^2 );
%         end
%         
%         a - b
%         function out = minus(obj1, obj2)
%             arguments
%                 obj1 Quantity
%                 obj2 Quantity
%             end
%            out = obj1 + (-obj2);
%         end
%         
%         a .* b
%         function out = times(obj1, obj2)
%             Quantity .* (double lub sym)
%             if isa(obj1, 'Quantity') && (isa(obj2, 'double') || isa(obj2, 'sym'))
%                 out = obj1;
%                 out.Value = out.Value * obj2;
%                 out.Uncertainty = out.Uncertainty * abs(obj2);
%                 if isa(obj2, 'sym')
%                    [~, unit] = separateUnits(obj2);
%                    out.Unit = out.Unit * unit;
%                 end
%             (double lub sym) .* Quantity
%             elseif isa(obj2, 'Quantity') && (isa(obj1, 'double') || isa(obj1, 'sym'))
%                 out = obj2;
%                 out.Value = out.Value * obj1;
%                 out.Uncertainty = out.Uncertainty * abs(obj1);
%                 if isa(obj1, 'sym')
%                    [~, unit] = separateUnits(obj1);
%                    out.Unit = out.Unit * unit;
%                 end
%             Quantity .* Quantity
%             elseif isa(obj1, 'Quantity') && isa(obj2, 'Quantity')
%                out = obj1;
%                out.IsConstant = max(out.IsConstant, obj2.IsConstant);
%                out.Value = out.Value * obj2.Value;
%                out.Uncertainty = sqrt( (out.Value * obj2.Uncertainty)^2 + ...
%                    (out.Uncertainty * obj2.Value));
%               
%             end
%         end 
%         
%         a ./ b
%         function out = rdivide(obj1, obj2)
%             Quantity ./ (double lub sym)
%             if isa(obj1, 'Quantity') && (isa(obj2, 'double') || isa(obj2, 'sym'))
%                 out = obj1 .* (1/obj2);
%                 if isa(obj2, 'sym')
%                    [~, unit] = separateUnits(obj2);
%                    out.Unit = out.Unit / unit;
%                 end
%             (double lub sym) ./ Quantity     
%             elseif isa(obj2, 'Quantity') && (isa(obj1, 'double') || isa(obj1, 'sym'))
%                 out = obj2;
%                 out.Value = obj2 ./ obj1.Value;
%                 out.Uncertainty = abs(obj1) * obj2.Uncertainty ./ (obj2.Value^2); 
%                 if isa(obj1, 'sym')
%                    [~, unit] = separateUnits(obj1);
%                    out.Unit = out.Unit / unit;
%                 end
%             Quantity ./ Quantity
%             elseif isa(obj1, 'Quantity') && isa(obj2, 'Quantity')
%                 out = obj1;
%                 out.IsConstant = max(obj1.IsConstant, obj2.IsConstant);
%                 out.Uncertainty = sqrt( (obj1.Uncertainty/obj2.Value)^2 + ...
%                     (obj1.Value * obj2.Uncertainty / (obj2.Value^2)));
%                 out.Value = obj1.Value / obj2.Value;
%                 out.Unit = obj1.Unit / obj2.Unit;
%             end
%         end
%         
%         -a
%         function out = uminus(obj)
%            out = obj;
%            out.Value = -1 * out.Value;
%         end
        
        
    end
    
    
    methods (Static)   
        obj = Constant(name, value, latexname)
        obj = C(an_fn, fn_name, index, args, preferredUnit, output_type, latexname)
        obj = B(fn_name, index, arg_names, arg_vals, deltas, preferredUnit, output_type, latexname)
        obj = AB(fn_name, index, arg_names, arg_vals, deltas, preferredUnit, output_type, latexname)
        obj = A(fn_name, index, arg_vals, preferredUnit, output_type, latexname)
    end
    
end

