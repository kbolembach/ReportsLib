function out = LSBorder(in)
%LSBORDER Zwraca rząd najmniej znaczącej cyfry liczby (jako wykładnik 10^x)

if string(in) == "0"
    out = 0;
else
    if ~isstring(in)
        out_str = string(vpa(in, 15));
    else
        out_str = in;
    end
    
    if contains(out_str, "e")
        exponent = extractBetween(out_str, strfind(out_str, 'e')+1, strlength(out_str));
        exponent = str2num(exponent);
        
        if contains(out_str, ".")
            exponent = exponent - strlength(extractBetween(out_str,...
                                    strfind(out_str, '.')+1, strfind(out_str, 'e')-1));
        end
        out = exponent;
    else
        if endsWith(out_str, ".0")
            out_str = extractBetween(out_str, 1, strlength(out_str)-2);
        end
        if count(out_str, '.') == 1
            out_str = extractBetween(out_str, strfind(out_str, '.'), strlength(out_str));
            out = 1-strlength(out_str);
        else
            out = 0;
        end
        out_str = convertStringsToChars(out_str);
        while out_str(end) == "0"
            out = out+1;
            out_str = out_str(1:end-1);
        end
    end
end
end

