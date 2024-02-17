# Skladovni avtomat

Skladovni avtomat je nadgradnja preprostega končnega avtomata. Dodamo mu namreč še sklad, ki služit kot (neskončen) spomin. Skladovni avtomat sprejme niz, ter se pomika po njegovih možnih stanjih, medtem pa na sklad nalaga oziroma odstranjuje elemente glede na njegovo tranzicijsko funkcijo. Avtomat sprejme niz, če konča v enem od sprejemnih stanj oziroma se sklad znajde v prvotnem stanju.

Za primer si oglejmo najpreprostejši primer skladovnega avtomata. Ta avtomat bo sprejel nize oblike 111...10...000, kjer je število enk v takem nizu natanko enako številu enk. Z lemo o napihovanju smo na predavanjih dokazali, da navaden končni avtomat ne premore sprejetih takih nizov, če ne predpostavimo, da je niz določene dolžine oziroma ne predpostavimo, da obstaja največja možna dolžina. 

Skladovni avtomat nam namreč v tem primeru omogoči, da si zapomnimo, koliko enk smo sprejeli, da neke točke in pri tem nas dolžine niza v nobenem smislu ne omejuje. Ideja je sledeča. Na začetku sprejemamo enice, in si jih nalagamo na sklad. Ko naletimo na ničle pa iz sklada odstranimo enice, in sicer za vsako videno ničlo odstranimo natanko eno enice. Tako bo avtomat sprejel nize, pri katerih se bo sklad na koncu znašel v natanko svojem prvotnem stanju, kar se zgodi natanko tedaj, ko je število enic enako številu ničel.

## Matematična definicija

Skladovni avtomat je sedmerica elementov $M = (Q,\Sigma, G, \delta, q_0, Z, F)$, pri čemer je :
- $Q$ končna množica stanj,
- $\Sigma$ končna množica znakov, ki jih sprejemamo, oziroma abececa,
- $G$ končna množica znakov, ki so lahko na skaldu,
- $\delta : Q \times \Sigma \times G \to Q \times (G \times G)$ je prehodna oziroma tranzicijska funkcija,
- $q_0 \in Q$ je začetno stanje,
- $Z \in G$ je začetni znak na skladu,
- $F \subseteq Q$ je množica sprejemljivih stanj.

Na primer, zgornji skladovni avtomat predstavimo z naborom $(\{0, 1\}, \{q_0, q_1, q_2\}, q_0, \{q_1\}, \delta)$, kjer je $\delta$ podana z naslednjo tabelo:
Na primer, zgornji skladovni avtomat predstavimo takole : 
- $Q = {q_i, q_1, q_0, q_f}$
- $\Sigma = {<, 1, 0, >}$. Znaka < in > uporabimo kot posebna znaka, ki predstavljata konec oziroma začetek niza
- $G = {z, 1, 0}$, pri čemer z služi kot začetni znak na skladu. V naši implementaciji smo namesto z uporabili znak, za ameriški dolar,
- $\delta$ predstavimo v spodnji tabeli,
- $q_0 = q_i$,
- $Z = z$ in
- $F = {q_f}$.
Sledečo tabelo je treba malce komentirati. Če označimo $\delta : (q, s, g) \mapsto (q', (x, y))$. V tem primeru se pomaknemo iz stanja $q$ v stanje $q'$ ob predpostavki, da preberemo znak $s$ in da je na vrhu sklada znak $g$. Poleg pomika po stanjih nam še to predstavlja spremembo na skladu, in sicer iz vrha sklada odstranimo element $y$ ter na sklad dodamo element $x$. Opomnimo, da je ta predpis smiselen natanko tedaj, ko velje $g = y$.
| $\delta$ | `0`   | `1`   |
| -------- | ----- | ----- |
| $(q_i, <, )$    | $q_0$ | $q_1$ |
| $q_1$    | $q_2$ | $q_0$ |
| $q_2$    | $q_1$ | $q_2$ |

## Navodila za uporabo

Ker projekt služi kot osnova za večje projekte, so njegove lastnosti zelo okrnjene. Konkretno implementacija omogoča samo zgoraj omenjeni končni avtomat. Na voljo sta dva vmesnika, tekstovni in grafični. Oba prevedemo z ukazom `dune build`, ki v korenskem imeniku ustvari datoteko `tekstovniVmesnik.exe`, v imeniku `html` pa JavaScript datoteko `spletniVmesnik.bc.js`, ki se izvede, ko v brskalniku odpremo `spletniVmesnik.html`.

Če OCamla nimate nameščenega, lahko še vedno preizkusite tekstovni vmesnik prek ene od spletnih implementacij OCamla, najbolje <http://ocaml.besson.link/>, ki podpira branje s konzole. V tem primeru si na vrh datoteke `tekstovniVmesnik.ml` dodajte še vrstice

```ocaml
module Avtomat = struct
    (* celotna vsebina datoteke avtomat.ml *)
end
```

### Tekstovni vmesnik

TODO

### Spletni vmesnik

TODO

## Implementacija

### Struktura datotek

TODO

### `avtomat.ml`

TODO

### `model.ml`

TODO
