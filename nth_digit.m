function d = nth_digit(A, n)
%NTH_DIGIT Zwraca n'tą cyfrę w zapisie liczby A (licząc od lewej).
    numDigits = floor(log10(abs(A))) + 1;
    d = mod(floor(A/10^(numDigits - n)), 10);
end