ateh(_, [], []).
ateh(E, [E|_], [E]).
ateh(E, [H|T], [H|Result]):- ateh(E, T, Result).

