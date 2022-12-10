function PlotErrorBars(qx, qy, nvargs)
%PLOTERRORBARS Funkcja pomocnicza do rysowania prostokątów niepewności
%wielkości qx, qy na wykresie. Dostępne opcje Name-Value:
%style - wybierz styl errorbarów (ze standardowych styli Matlaba)
%step - rysuj prostokąty niepewności dla punktów co step (=1)
%offset - zacznij rysować prostokąty niepewności od punktu o tym indexie

arguments
   qx
   qy
   nvargs.style = 'k.'
   nvargs.step = 1
   nvargs.offset = 1
end

x = GetValue(qx, 1);
y = GetValue(qy, 1);

xerr = GetUncertainty(qx, 1);
yerr = GetUncertainty(qy, 1);
errorbar(x(nvargs.offset:nvargs.step:end), y(nvargs.offset:nvargs.step:end), ...
    yerr(nvargs.offset:nvargs.step:end), yerr(nvargs.offset:nvargs.step:end), ...
    xerr(nvargs.offset:nvargs.step:end), xerr(nvargs.offset:nvargs.step:end), nvargs.style);
end

