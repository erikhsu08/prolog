tri([], []).
tri([X|Resto], [X,X,X|Resultado]):- tri(Resto, Resultado).
