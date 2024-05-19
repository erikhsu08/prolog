/* Leitura do arquivo */
le_arq(Arq, Conteudo) :-
    open(Arq, read, Stream),
    read_stream(Stream, Conteudo),
    close(Stream).

read_stream(Stream, []) :-
    at_end_of_stream(Stream), !.
read_stream(Stream, [Char|Chars]) :-
    get_char(Stream, Char),
    read_stream(Stream, Chars).

/* Contagem de frequências */
count_freqs(Chars, Freqs) :-
    msort(Chars, SortedChars),  % msort to maintain duplicates
    pack(SortedChars, PackedChars),
    maplist(length_char, PackedChars, Freqs).

pack([], []).
pack([X|Xs], [[X|Ys]|Zs]) :-
    transfer(X, Xs, Ys, Rest),
    pack(Rest, Zs).

transfer(X, [], [], []).
transfer(X, [Y|Ys], [], [Y|Ys]) :-
    X \= Y.
transfer(X, [X|Xs], [X|Ys], Rest) :-
    transfer(X, Xs, Ys, Rest).

length_char(List, (Char, Length)) :-
    List = [Char|_],
    length(List, Length).

/* Construção da árvore de Huffman */
build_tree(Freqs, Tree) :-
    maplist(singleton, Freqs, Trees),
    huffman(Trees, Tree).

singleton((Char, Freq), tree(Freq, Char, empty, empty)).

huffman([Tree], Tree).
huffman(Trees, FinalTree) :-
    sort_trees(Trees, SortedTrees),
    SortedTrees = [T1, T2|Rest],
    merge_trees(T1, T2, MergedTree),
    huffman([MergedTree|Rest], FinalTree).

sort_trees(Trees, SortedTrees) :-
    sort(1, @=<, Trees, SortedTrees).

merge_trees(tree(F1, C1, L1, R1), tree(F2, C2, L2, R2), tree(F, nil, tree(F1, C1, L1, R1), tree(F2, C2, L2, R2))) :-
    F is F1 + F2.

/* Geração dos códigos de Huffman */
generate_codes(Tree, Codes) :-
    generate_codes(Tree, [], Codes).

generate_codes(empty, _, []).
generate_codes(tree(_, Char, empty, empty), Prefix, [(Char, Prefix)]).
generate_codes(tree(_, _, Left, Right), Prefix, Codes) :-
    append(Prefix, [0], LeftPrefix),
    append(Prefix, [1], RightPrefix),
    generate_codes(Left, LeftPrefix, LeftCodes),
    generate_codes(Right, RightPrefix, RightCodes),
    append(LeftCodes, RightCodes, Codes).

/* Codificação do texto */
encode_text([], _, []).
encode_text([Char|Chars], Codes, EncodedText) :-
    member((Char, Code), Codes),
    encode_text(Chars, Codes, RestEncodedText),
    append(Code, RestEncodedText, EncodedText).

/* Escrita do arquivo */
write_file(Arq, Conteudo) :-
    open(Arq, write, Stream),
    write_Conteudo(Stream, Conteudo),
    close(Stream).

write_Conteudo(_, []).
write_Conteudo(Stream, [Bit|Bits]) :-
    write(Stream, Bit),
    write_Conteudo(Stream, Bits).

/* Função principal */
huffman_encode :-
    le_arq('in.txt', Conteudo),
    format("Conteudo lido de in.txt: ~s~n", [Conteudo]),
    count_freqs(Conteudo, Freqs),
    build_tree(Freqs, Tree),
    generate_codes(Tree, Codes),
    encode_text(Conteudo, Codes, EncodedText),
    write_file('out.txt', EncodedText).

/* Função para excluir pontuações */
eh_pontuacao(Char) :- char_type(Char, punct).


/* Função para converter lista de códigos binários em string. 
    Por exemplo ['1','0','1','1'] vira a string "1011" */

lista_toString([], Acc, Acc).
lista_toString([H|T], Acc, String) :-
    lista_toString(T, [H|Acc], String).
