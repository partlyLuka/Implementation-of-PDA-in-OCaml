# Implementation-of-PDA-in-OCaml
V tem projektu bomo implementirali skladovne avtomate v OCamlu. 
## Definicija
Skladovni avtomat je sedmerica elementov M = (Q,S, G, d, q0, Z, F), pri čemer je :
1. Q končna množica stanj,
2. S končna množica znakov, ki jih sprejemamo,
3. G končna množica znakov, ki so lahko na skaldu,
4. d je preslikava (Q, S, G) -> (Q, G*), pri čemer je G* množica vseh končnih nizov nad G,
5. q0 je začetno stanje,
6. Z je začetno stanje na skladu,
7. F je množica sprejemljivih stanj.
## Primer
Primer skladovnega avtomata je avtomat, ki sprejema nize oblika 1111...1000...0 in preveri, ali je število enic enako števil ničel. 
Neformalno rečeno bo najprej avtomat inicializiral sklad z začetnim znakom $, nato bo nanj potisnil toliko enic, kot je 1 v nizu. Nato bo za vsako ničlo v nizu iz sklada potisnil 1. Naposled bo odstranil še simbol $. Niz bo sprejet če se bo lahko izvedel zadnji korak oz. če bo sklad prazen.

