#autor Jakub Kołakowski

using mymodule


# DANE
delta = 0.1^4; epsilon = 0.1^4;



h(x) = exp(x) - 3x;


a = 0.0; b = 1.0;
r, v, it, err = mbisekcji(h, a, b, delta, epsilon);
println("pierwszy pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);

a = -100000.0; b = 1.0;
r, v, it, err = mbisekcji(h, a, b, delta, epsilon);
println("pierwszy pierwiastek 3: ", r, ", wartosc w x1: ", v, ", liczba iteracji: ", it, "  ", err);

a = 1.0; b = 2.0;
r, v, it, err = mbisekcji(h, a, b, delta, epsilon);
println("drugi pierwiastek: ", r, ", wartosc w x1: ", v, ", liczba iteracji: ", it, "  ", err);

a = 1.0; b = 100000.0;
r, v, it, err = mbisekcji(h, a, b, delta, epsilon);
println("drugi pierwiastek 2: ", r, ", wartosc w x1: ", v, ", liczba iteracji: ", it, "  ", err);
