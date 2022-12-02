function out = Regexify(in)
%REGEXIFY Przygotowuje string do bycia użytym w wyrażeniu regularnym
%(dodaje znaki ucieczki).

out = strrep(in, "\", "\\");
out = strrep(out, "{", "\{");
out = strrep(out, "}", "\}");
out = strrep(out, "(", "\(");
out = strrep(out, ")", "\)");
out = strrep(out, ".", "\.");
out = strrep(out, "+", "\+");
out = strrep(out, "*", "\*");
out = strrep(out, "?", "\?");
out = strrep(out, "^", "\^");
out = strrep(out, "$", "\$");
out = strrep(out, "[", "\[");
out = strrep(out, "]", "\]");
out = strrep(out, "|", "\|");

end

