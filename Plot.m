function  Plot(arg_x, arg_y, plot_title, plot_xlabel, plot_ylabel, plot_legend, errorbars)
%PLOT Wykreśla wykres wielości fizycznych arg_x i arg_y z tytułem plot_title,
%oznaczeniami osi plot_xlabel, plot_ylabel oraz legendą wykresu plot_legend
%(cell array). Ustaw errorbars = 0 by nie wykreślać prostokątów niepewności na wykresie.

arguments
    arg_x Quantity
    arg_y Quantity
    plot_title string
    plot_xlabel string
    plot_ylabel string
    plot_legend string
    errorbars {mustBeMember(errorbars, [0, 1])} = 1
end

x = double(GetValue(arg_x, 1));
y = double(GetValue(arg_y, 1));

plot(x, y, '.k');

if errorbars
    PlotErrorBars(arg_x, arg_y);
end

title("$$ " + plot_title + " $$", 'Interpreter', 'latex', 'FontSize', 20);
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')
xlabel("$$ " + plot_xlabel + " $$",'Interpreter','latex','FontSize',20);
ylabel("$$ " + plot_ylabel + " $$",'Interpreter','latex','FontSize',20);
set(legend(plot_legend), 'Interpreter', 'latex', 'Location', 'southeast', 'FontSize', 12)
end

