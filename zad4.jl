#autor Jakub Kołakowski
using mymodule


# DANE
a = 1.5; b = 2.0; delta = 0.1^5 / 2; epsilon = 0.1^5 / 2;
maxit = 30;
f(x) = sin(x) - (x/2)^2;
pf(x) = cos(x) - (x/2); # pochodna

# PODPUNKT 1
r, v, it, err = mbisekcji(f , a, b, delta, epsilon);
println("Bisekcja, pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);


# PODPUNKT 2
x0 = 1.5;
r, v, it, err = mstycznych(f, pf, x0, delta, epsilon, maxit);
println("Styczne(Newton), pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);


#PODPUNKT 3
x0 = 1.0; x1 = 2.0;
r, v, it, err = msiecznych(f, x0, x1, delta, epsilon, maxit);
println("Sieczne, pierwiastek: ", r, ", wartosc w x0: ", v, ", liczba iteracji: ", it, "  ", err);
