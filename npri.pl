npri(1, [1]).
npri(N, [N|Resto]):- 
    N > 1, 
    N1 is N - 1, 
    npri(N1, Resto).