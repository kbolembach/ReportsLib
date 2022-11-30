function PlotErrorBars(qx, qy)
%PLOTERRORBARS Helper function used to plot error bars on a graph given
%quantities qx, qy. PLotted error bars are just the respective quantities'
%uncertainities.
x = GetValue(qx, 1);
y = GetValue(qy, 1);
xerr = GetUncertainty(qx, 1);
yerr = GetUncertainty(qy, 1);
errorbar(x, y, yerr, yerr, xerr, xerr, 'k.');
end

