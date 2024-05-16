apos(_, [], []).
apos(E, [E|Es], Es).
apos(E, [_|Es], Result):- apos(E, Es, Result).