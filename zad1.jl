#autor Jakub Kołakowski

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
max = 800;


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
