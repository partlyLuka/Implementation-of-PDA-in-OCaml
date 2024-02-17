# Skladovni avtomat

Skladovni avtomat je nadgradnja preprostega končnega avtomata. Dodamo mu namreč še sklad, ki služit kot (neskončen) spomin. Skladovni avtomat sprejme niz, ter se pomika po njegovih možnih stanjih, medtem pa na sklad nalaga oziroma odstranjuje elemente glede na njegovo tranzicijsko funkcijo. Avtomat sprejme niz, če konča v enem od sprejemnih stanj oziroma se sklad znajde v prvotnem stanju.

Za primer si oglejmo najpreprostejši primer skladovnega avtomata. Ta avtomat bo sprejel nize oblike 111...10...000, kjer je število enk v takem nizu natanko enako številu enk. Z lemo o napihovanju smo na predavanjih dokazali, da navaden končni avtomat ne premore sprejetih takih nizov, če ne predpostavimo, da je niz določene dolžine oziroma ne predpostavimo, da obstaja največja možna dolžina. 

Skladovni avtomat nam namreč v tem primeru omogoči, da si zapomnimo, koliko enk smo sprejeli, da neke točke in pri tem nas dolžine niza v nobenem smislu ne omejuje. Ideja je sledeča. Na začetku sprejemamo enice, in si jih nalagamo na sklad. Ko naletimo na ničle pa iz sklada odstranimo enice, in sicer za vsako videno ničlo odstranimo natanko eno enice. Tako bo avtomat sprejel nize, pri katerih se bo sklad na koncu znašel v natanko svojem prvotnem stanju, kar se zgodi natanko tedaj, ko je število enic enako številu ničel.

## Matematična definicija

Skladovni avtomat je sedmerica elementov $M = (Q,\Sigma, G, \delta, q_0, Z, F)$, pri čemer je :
- $Q$ končna množica stanj,
- $\Sigma$ končna množica znakov, ki jih sprejemamo, oziroma abececa,
- $G$ končna množica znakov, ki so lahko na skaldu,
- $\delta : Q \times \Sigma \times G \to Q \times ( G \times G)$ je prehodna oziroma tranzicijska funkcija,
- $q_0 \in Q$ je začetno stanje,
- $Z \in G$ je začetni znak na skladu,
- $F \subseteq Q$ je množica sprejemljivih stanj.



Na primer, zgornji skladovni avtomat predstavimo takole : 
- $Q = \{q_i, q_1, q_0, q_f\}$
- $\Sigma = \{, 1, 0, \}$. Znaka < in > uporabimo kot posebna znaka, ki predstavljata konec oziroma začetek niza
- $G = \{z, 1, 0\}$, pri čemer z služi kot začetni znak na skladu. V naši implementaciji smo namesto z uporabili znak, za ameriški dolar,
- $\delta$ predstavimo v spodnji tabeli,
- $q_0 = q_i$,
- $Z = z$ in
- $F = \{q_f\}$.

Sledečo tabelo je treba malce komentirati. Če označimo $\delta : (q, s, g) \mapsto (q', (x, y))$. V tem primeru se pomaknemo iz stanja $q$ v stanje $q'$ ob predpostavki, da preberemo znak $s$ in da je na vrhu sklada znak $g$. Poleg pomika po stanjih nam še to predstavlja spremembo na skladu, in sicer :
- Če velja $(x, y) = (,)$, pomeni, da iz sklada odstranimo vrh sklada, torej $g$,
- Če velja $(x, y) = (,g)$, pomeni, da sklada ne spreminjamo,
- Če velja $(x, y) = (x, g)$, pomeni, da na sklad dodamo element $x$,
- V drugih primerih predpis ni smiselen.

| $\delta$        | Novo stanje   | Sprememba na skladu   |
| --------------- | ----- | ----- |
| $q_i, <, z$   | $q_1$ | $(, z)$ |
| $q_1, 1, z$   | $q_1$ | $(1 , z)$ |
| $q_1, 1, 1$   | $q_1$ | $(1 , 1)$ |
| $q_1, 0, 1$   | $q_0$ | $(,)$ |
| $q_0, 0, 1$   | $q_0$ | $(, )$ |
| $q_0, >, z$   | $q_f$ | $(, z)$ |


## Navodila za uporabo

Projekt vsebuje implementacijo skladovnih avtomatov v OCamlu. Na voljo je tekstovni vmestnik, navodila za njegovo uporabo so v spodnjem razdelku. Z ukazom dune build ustvarite .exe datoteko, ki služi kot glavna datoteka, kar se tiče izvedbe in uporabe programa. 

### Tekstovni vmesnik

Z ukazom dune build ustvarite .exe datoteko. Poženeto jo z ukaxom dune exe ./ime_datoteke.exe. 

Tekstovni vmesnik ima sledeče funkcionalnosti : 
- Lahko preizkusite uporabo zgoraj omenjenega avtomata. Vmesnik vas jasno vodi skozi njegovo uporabo.
- Lahko ustvari svoj osebni skladovni avtomat po vaši želji in ga preizkusite na poljubnih nizih.
- Ko imate izbrani oziramo izdelani avtomat ga lahko preizkusite na dva načina. Lahko mu preprosto podate niz, vmesnik pa vam bo sporočil, ali je bil niz sprejet. Drugi način je bolj nazoren za razumevanje, in sicer nudi iterativno pomikanje po nizu. To pomeni, da lahko znak za znak vnašate niz. Sproti se vam bo izpisovalo stanje avtomata in stanje na skladu. Ko pridete do konca niza preprosto stisnite enter (vnesite prazen niz).

Naj opozorimo in predlagamo, da sleherni niz, ki ga boste vnesli malce spremenite, in sicer na začetek dodajte '<' ter na konec '>'. Tak dogovor zelo hitro pomete z veliko preglavicami, ampak je seveda tudi odvisen od vaše same implementacije skladovnega avtomaa, če se boste za to odločili.

Za iterativno vnašanje je morda potreben primer za nazorno razlago. Recimo, da želimo vnesti niz '1100'. Za iterativno vnašanje bi vnesli naslednje nize (v takem vrstnem red8):
- '<1100>'
- '1100>'
- '100>'
- '00>'
- '0>'
- '>'
- '' (prazen niz)

Alternativno bi lahko vnašali tudi :
- '<'
- '1'
- '1'
- '0'
- '0'
- '>'
- '' (prazen niz)



## Implementacija

### Struktura datotek

Pomembna mapa je mapa 'src', ki kateri sta mapi 'definicije' in 'tekstoVmesnik'.

V mapi 'definicije' so .ml datoteke, ki katerih je implementiran skladovni avtomat. Ta mapa je sestavljena iz sledečih .ml datotek.

### `avtomat.ml`

Tu je implementiran skladovni avtomat. Poleg tega so priložene še pomožne funkcije za delo s skladovnimi avtomati. Podana je tudi implementacija zgornjega primera. Poleg tega so spisane funkcije, ki pomagajo pri interaktivnem sestavljanju svojega skladovnega avtomata. 

### `sklad.ml`

V tej datoteki je implementiran sklad, ki ga dodamo tipe avtomata v datoteki avtomat.ml.

### `stanje.ml`

V tej datoteki je implementiran tip stanja, ki služi kot nepogrešljiv del tipe avtomata v datoteki avtomat.ml.

V mapi ''tekstovniVmesnik' je le ena .ml datoteka, in sicer 'tekstovniVmesnik.ml'.

### `tekstovniVmesnik.ml`
Datoteka implementira tekstovni vmesnik ter uporabi tipe ter funnkcije iz datotek iz mape 'definicije'. Na koncu celoto poveže funkcia ''main ()'.
