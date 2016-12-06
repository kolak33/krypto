#autor Jakub Kołakowski
module mymodule


export mbisekcji
export mstycznych
export msiecznych

#   METODA bisekcji (połowienia przedziału)

#   PARAMETRY WEJŚCIOWE:
#   f - funkcja anonimowa,
#   a,b - końce przedziału początkowego
#   delta, epsilon - dokładności obliczeń

#   PARAMETRY WYJŚCIOWE
#   r - przyblizenie pierwiastka rownania f(x) = 0
#   v - wartość f(r)
#   it - liczba wykonanych iteracji
#   err - sygnalizacja błędu
#       0 - brak błędu
#       1 - funkcja nie zmienia znaku w przedziale [a,b]

# Dodatkowo parametr max - maxymalna ilość wykonywanych iteracji
max = 40;


function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    a_wart = f(a);
    b_wart = f(b);
    dl_przedzialu = b-a;

    if(sign(a_wart) == sign(b_wart))  return 0,0,0,1; # zwraca blad - 1, funkcja nie zmienia znaku na przedziale
    end

    for it = 1 : max
        dl_przedzialu = dl_przedzialu / 2;
        c = a + dl_przedzialu;
        c_wart = f(c);

        if(abs(dl_przedzialu) < delta || abs(c_wart) < epsilon)
            return c, c_wart, it, 0;
        end

        if(sign(c_wart) == sign(a_wart)) #jezeli znak na srodku przedzialu jest taki sam jak ten na lewym koncu
            a = c;
            a_wart = c_wart;
        else
            b = c;
            b_wart = c_wart;
        end
    end
end









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


end
