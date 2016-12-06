#autor Jakub Kołakowski

#   METODA SIECZNYCH

#   PARAMETRY WEJŚCIOWE:
#   f - funkcja f(x) zadana jako funkcje anonimowe,
#   x0, x1 - przyblizenia poczatkowe
#   delta, epsilon - dokładności obliczeń
#   maxit - dopuszczalna maxymalna liczba iteracji

#   PARAMETRY WYJŚCIOWE
#   r - przyblizenie pierwiastka rownania f(x) = 0
#   v - wartość f(r)
#   it - liczba wykonanych iteracji
#   err - sygnalizacja błędu
#       0 - metoda zbiezna
#       1 - nie osiągnięto wymaganej dokładności w maxit iteracji


function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    x0_wart = f(x0);
    x1_wart = f(x1);
    it = 1;
    for it = 1 : maxit
        if(abs(x0_wart) > abs(x1_wart)) # dzieki temu moduly wartosci funkcji w punktach xn nie rosna
            tmp = x0;
            x0 = x1;
            x1 = tmp;

            tmp = x0_wart;
            x0_wart = x1_wart;
            x1_wart = tmp;
        end

        s = (x1 - x0) / (x1_wart - x0_wart);
        x1 = x0;
        x1_wart = x0_wart;
        x0 = x0 - x0_wart * s;
        x0_wart = f(x0);

        if(abs(x0_wart) < epsilon || abs(x1 - x0) < delta) #   metoda zbiezna
            return x0, x0_wart, it, 0;
        end
    end

    return x0, x0_wart, it, 1; #  nie osiągnięto wymaganej dokladnosci w maxit iteracji
end
