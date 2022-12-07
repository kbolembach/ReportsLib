function PlotErrorBars(qx, qy, nvargs)
%PLOTERRORBARS Funkcja pomocnicza do rysowania errorbarów na wykresie
%wielkości qx, qy. Errorbary reprezentują niepewności tych wartości.

arguments
   qx
   qy
   nvargs.style = 'k.'
end

x = GetValue(qx, 1);
y = GetValue(qy, 1);
xerr = GetUncertainty(qx, 1);
yerr = GetUncertainty(qy, 1);
errorbar(x, y, yerr, yerr, xerr, xerr, nvargs.style);
end

