# ReportsLib
 Library for easy reports calculations and writing
 
## Why ReportsLib?
This library allows you to easily process measurement data including calculations of type A, type B and type C uncertainities of the measurements. The results are returned as raw and rounded numbers, including rules on rounding numbers with uncertainities. It also compiles LaTeX equations for you, so you can easily use them in your report (provides symbolic equations as well as equations with numbers plugged into them). You can also easily print an almost-ready LaTeX table with a specified header and data.

## How to use
ReportsLib revolves around a class Quantity, whose objects can be used to store information on some physical quantity with a value and uncertainty along with some additional info like its name and LaTeX representation.

Create an object describing a constant of nature:

```
e = Quantity.Constant("e", sym(1.602 * 10^(-19)));
```

Describe a current measured using a meter with some uncertainty (type B):

```
I = Quantity.B("I", "p", raw_I, raw_I * 0.05 / sqrt(3));
```

Batch process measurements:

```
for i=length(raw_U):-1:1 
   I(i) = Quantity.B("I", "p", raw_I(i), raw_I(i) * 0.05 * sqrt(3), index=i, output=output_mode);
   U(i) = Quantity.B("U", "p", raw_U(i), raw_U(i) * 0.05 * sqrt(3), index=i, output=output_mode); 
end
```

Automatically calculate type C uncertainities given an array of Quantity objects and an equation:

```
an_quadratic = @(a, b, c) c - (b^2 / (4*a));
I_max = Quantity.C(an_quadratic, "I_max", [a, b, c]);
```


### TO-DO:
- Allow for display of numbers in a scientific fashion, e.g. 0.67 * 10^-19 instead of printing lots of zeros
- Work on the A-type uncertainty class
