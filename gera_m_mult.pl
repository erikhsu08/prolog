gera_m_mult(N, M, Lista):- gera_m_mult_aux(N, N, M, Lista).

gera_m_mult_aux(_, Atual, M, []):- Atual > M.
gera_m_mult_aux(N, Atual, M, [Atual|Resto]):-
    Atual =< M,
    RestoAtual is Atual + N,
    gera_m_mult_aux(N, RestoAtual, M, Resto).

