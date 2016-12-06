#autor Jakub Kołakowski

#   METODA STYCZNYCH (METODA NEWTONA)

#   PARAMETRY WEJŚCIOWE:
#   f, pf - funkcja f(x), oraz pochodna f'(x) zadane jako funkcje anonimowe,
#   x0 - przyblizenie poczatkowe
#   delta, epsilon - dokładności obliczeń
#   maxit - dopuszczalna maxymalna liczba iteracji

#   PARAMETRY WYJŚCIOWE
#   r - przyblizenie pierwiastka rownania f(x) = 0
#   v - wartość f(r)
#   it - liczba wykonanych iteracji
#   err - sygnalizacja błędu
#       0 - metoda zbiezna
#       1 - nie osiągnięto wymaganej dokładności w maxit iteracji
#       2 - pochodna bliska zeru

function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    x1 = 0.0;
    it = 1;
    x0_wart = f(x0);
    if(abs(x0_wart) < epsilon)
        return x0, x0_wart, 0, 0; #    metoda zbiezna
    end

    for it = 1 : maxit
        if(abs(pf(x0)) < 4eps(Float64)) #    pochodna bliska zeru
            return x0, x0_wart, it-1, 2;
        end

        x1 = x0 - x0_wart / pf(x0);
        x0_wart = f(x1);

        if(abs(x1 - x0) < delta || abs(x0_wart) < epsilon) #    metoda zbiezna
            return x1, x0_wart, it, 0;
        end
        
        x0 = x1;
    end

    return x1, x0_wart, it, 1; #    nie osiagnieto wymaganej dokladnosci w maxit iteracji
end
