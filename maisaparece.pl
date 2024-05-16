% Caso base: se a lista está vazia, não há elemento que mais aparece
mais_aparece([], _) :-
    fail.

% Caso base: se há apenas um elemento na lista, esse elemento é o que mais aparece
mais_aparece([Elemento], Elemento).

% Caso recursivo: contagem dos elementos
mais_aparece(Lista, MaisFrequente) :-
    mapear_elementos(Lista, Pares),
    contar_ocorrencias(Pares, Ocorrencias),
    max_ocorrencias(Ocorrencias, MaisFrequente).

% Predicado para mapear cada elemento da lista com o número de ocorrências
mapear_elementos([], []).
mapear_elementos([X|Resto], [(X,1)|RestoPares]) :-
    mapear_elementos(Resto, RestoPares).

% Predicado para contar ocorrências de cada elemento
contar_ocorrencias([], []).
contar_ocorrencias([(X,N)|T], [(X,N1)|T1]) :-
    contar_ocorrencias(T, T1),
    contar(X, T, N, N1).

contar(_, [], N, N).
contar(X, [(X,_)|T], N, N1) :-
    N1 is N + 1,
    contar(X, T, N, _).
contar(X, [(_,_)|T], N, N1) :-
    contar(X, T, N, N1).

% Predicado para encontrar o elemento com o maior número de ocorrências
max_ocorrencias([(X,N)], X).
max_ocorrencias([(X,N)|T], MaisFrequente) :-
    max_ocorrencias(T, MaisFrequenteResto),
    contar_ocorrencias_de_maior(X, N, MaisFrequenteResto, MaisFrequente).

contar_ocorrencias_de_maior(X, N, (Y, M), X) :-
    N > M.
contar_ocorrencias_de_maior(_, _, (Y, M), Y) :-
    M >= N.

% Exemplo de uso:
% mais_aparece([1, 2, 3, 2, 3, 2, 1, 2, 2, 3, 3, 3], ElementoMaisFrequente).
