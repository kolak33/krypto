#autor Jakub Kołakowski
include("zad1.jl")
include("zad2.jl")
include("zad3.jl")

delta = 0.1^5 / 2; epsilon = 0.1^5 / 2; maxit = 20;
g(x) = 3x + 2;
pg(x) = 3; #pochodna g(x)

#TEST BISEKCJA
println("TEST BISEKCJA");
a = -10.0; b = 0.0;
r, v, it, err = mbisekcji(g , a, b, delta, epsilon);
println("pierwszy pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

a = 0.0; b = 10.0;
r, v, it, err = mbisekcji(g , a, b, delta, epsilon);
println("drugi pierwiastek: ", r, ", wartosc w x1: ", v, ", liczba iteracji: ", it, "  ", err);


#TEST STYCZNE
println("TEST STYCZNE");
x0 = 5.0;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek1: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 100000.0;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("drugi pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 0.0;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("brak pierwiastka: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 0.5;
r, v, it, err = mstycznych(g, pg, x0, delta, epsilon, maxit);
println("pierwszy pierwiastek4: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);



#TEST SIECZNE
println("TEST SIECZNE");
x0 = 4.0; x1 = 6.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0,x1 za pierwiastkiem na +: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = 1.0; x1 = 4.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1, pomiedzy pierwiastkiem na +: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -4.0; x1 = -3.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1 przed pierwiastkiem na -: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -3.0; x1 = -1.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1 pomiedzy pierwiastkiem na -: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -1.0; x1 = 1.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1 pomiedzy obiema pierwiastkami1: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

x0 = -99900.0; x1 = -90000.0;
r, v, it, err = msiecznych(g, x0, x1, delta, epsilon, maxit);
println("x0, x1 pomiedzy obiema pierwiastkami2: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);
