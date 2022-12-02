function [] = WriteLatexTable(filename, header, subheader, data)
%WRITELATEXTABLE Tworzy tablicę gotową do wklejenia do pliku .tex
%> filename - nazwa pliku;
%> header - tablica zawierająca wpisy headera tabelki;
%> subheader - tablica zawierająca wpisy subheaddera tabelki;
%> data - wektor wektorów z danymi (dane muszą być wektorami pionowymi).

[data_size_x, data_size_y] = size(data);
contents = strings(data_size_x +2,1);

for i=1:1:length(header)-1
    contents(1) = contents(1) + header(i) + " & ";
end
contents(1) = contents(1) + header(length(header)) + " \\";

for i=1:1:length(subheader)-1
    contents(2) = contents(2) + subheader(i) + " & ";
end
contents(2) = contents(2) + subheader(length(subheader)) + " \\\hline";

for i=3:1:data_size_x+2
   for j=1:1:data_size_y
       if j == data_size_y
           contents(i) = contents(i) +  data(i-2, j) + " \\\hline";
       else
        contents(i) = contents(i) +  data(i-2, j) + " & ";
       end
   end
end
fid = fopen(filename, 'wt');
fprintf(fid, '%s\n', contents);
fclose(fid);
end

