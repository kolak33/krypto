#autor Jakub Kołakowski
include("mymodule.jl")
using mymodule

#Funkcja 1

f(x) = exp(1 - x) - 1;
pf(x) = -exp(1 - x);

delta = 0.1^5; epsilon = 0.1^5; maxit = 40;

println("Funkcja 1. BISEKCJA");
a = -10.0; b = 10.0;
r, v, it, err = mbisekcji(f, a, b, delta, epsilon);
println("pierwszy pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);



println("Funkcja 1. STYCZNE");
x0 = -20.0;
r, v, it, err = mstycznych(f, pf, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek1: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 10.0;
r, v, it, err = mstycznych(f, pf, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek2: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 20.0;
r, v, it, err = mstycznych(f, pf, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek4: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 3.0;
r, v, it, err = mstycznych(f, pf, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek2: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);



println("Funkcja 1. SIECZNE");
x0 = 5.0; x1 = 6.0; # tu dziwny wynik lol
r, v, it, err = msiecznych(f, x0, x1, delta, epsilon, maxit);
println("x0,x1 za pierwiastkiem na +: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 2.0; x1 = 4.0;
r, v, it, err = msiecznych(f, x0, x1, delta, epsilon, maxit);
println("x0, x1, pomiedzy pierwiastkiem na +: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -4.0; x1 = -3.0;
r, v, it, err = msiecznych(f, x0, x1, delta, epsilon, maxit);
println("x0, x1 przed pierwiastkiem na -: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

#Funkcja 2

g(x) = x * exp(-x);
pg(x) = -exp(-x)*(x-1) # lub exp(-x) - x * exp(-x)


println("Funkcja 2. BISEKCJA");
a = -10.0; b = 8.0;
r, v, it, err = mbisekcji(g, a, b, delta, epsilon);
println("pierwszy pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

a = -2.0; b = 3.0;
r, v, it, err = mbisekcji(g, a, b, delta, epsilon);
println("pierwszy pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);



println("Funkcja 2. STYCZNE");
x0 = -3.0;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek1: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -10.0;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek2: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 3.0;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek2: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);



println("Funkcja 2. SIECZNE");
x0 = 5.0; x1 = 6.0; # tu dziwny wynik lol
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0,x1 za pierwiastkiem na +: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -1.0; x1 = 1.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1, pomiedzy pierwiastkiem na +: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -15.0; x1 = -12.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1 przed pierwiastkiem na -: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);
