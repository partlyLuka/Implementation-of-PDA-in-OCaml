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
- $Q = \{q_i, q_1, q_0, q_f\}$, pri čemer $q_i$ predstavlja stanje, v katerem sprejmemo začetni znak, $q_1$ stanje, v katerem bomo na sklad dodajali enice, $q_0$ stanje, v katerem bomo za vsako videno ničlo odstranili eno enico in $q_f$ predstavlja sprejemno stanje,
- $\Sigma = \{ <, 1, 0, > \}$. Znaka < in > uporabimo kot posebna znaka, ki predstavljata konec oziroma začetek niza
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
- Ko imate izbrani oziramo izdelani avtomat ga lahko preizkusite na dva načina. Lahko mu preprosto podate niz, vmesnik pa vam bo sporočil, ali je bil niz sprejet. Drugi način je bolj nazoren za razumevanje, in sicer nudi iterativno pomikanje po nizu. To pomeni, da lahko znak za znak vnašate niz. Sproti se vam bo izpisovalo stanje avtomata in stanje na skladu. Ko pridete do konca niza preprosto stisnite enter (vnesite prazen niz).Tedaj vam bo vmesnik tudi izpisal ali je bil niz v celoti sprejet. 

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
Poglejmo si še zgoraj opisani primer v samem tekstovnem vmesniku.

Najprej nas tekstovni vmesnik vpraša, ali želimo uporabiti že implementirani primer, ali pa bomo sestavili svoj avtomat. 
```plaintext
Pozdravljeni v svetu skladovnih avtomatov!
Trenutno imate 3 možnosti :
1) Lahko preizkustie v naprej pripravljen skladovni avtomat, ki preveri, ali je niz oblike 111..10...000, torej ima enako število enk kot ničel in je takšne oblike
2) Lahko naredit svoj, res SVOJ, skladovni avtomat in ga preizkusite na čisto svojih primerih
3) Lahko se odrečete užitku preizkuševanja in grajenju skladovnih avtomatov
Izbira je vaša.
```
Načeloma bi izbrali 1) in nadaljevali, a na hitro pokažimo, kako bi naredili svoj avtomat : 
```plaintext
2
Ali ste pripravljeni na izjemno avanturo, v kateri bomoo naredili prav SVOJ skladovni avtomat?Ja
Najprej začetno stanje.Vnesi ime stanja. >qi
Zdaj bomo določili začetni sklad.
Vnesi natanko en znak, ki želiš, da je na dnu sklada. (Hint : napiši $) >$
Avtomatu lahko dodamo sprejemno stanje, dodamo nesprejemno stanje ter dodamo prehod.
1) Če želite dodati nesprejemno stanje
2) Če želite dodati sprejemno stanje.
3) Če želite dodati prehod
4) Če si želite ogledati avtomat oz. mojstrovino v nastajanju
5) Če ste zadovoljni s svojim avtomatom, ali pa če ste se naveličali.
```
Tedaj nas vmesnik vodi skozi izgradnjo. Morda pokažimo le, kako bi dodali prehod : 

```plaintext
3
Najprej vnesi stanje, iz katerega se bomo pomaknili. Vnesi ime stanja. >qi
Vnesi znak, ki bi ga sprejeli. ><
Vnesi pričakovano vrednost na vrhu sklada. >$
Vnesi stanje, v katerega bi se naj pomaknili. >Vnesi ime stanja. >q1
pop ) Iz vrha sklada popnemo element
push ) Na sklad pushnemo element
null ) Sklad pustimo na miru
null
Avtomatu lahko dodamo sprejemno stanje, dodamo nesprejemno stanje ter dodamo prehod.
1) Če želite dodati nesprejemno stanje
2) Če želite dodati sprejemno stanje.
3) Če želite dodati prehod
4) Če si želite ogledati avtomat oz. mojstrovino v nastajanju
5) Če ste zadovoljni s svojim avtomatom, ali pa če ste se naveličali.
4
Avtomat :
Seznam vseh stanj : 
qi |  
Začetno stanje:
qi
Seznam sprejemnih stanj : 
 
Seznam prehodov :
 
qi  <  $  q1   na sklad :  [ $  ] 
Seznam sklada : 
$ 
Posebni znak : 
$
```
Zgornja reprezentacija terje le eno pojasnilo. Spremembo na skladu $(a, b)$ zakodiramo kot senzma $[a, b]$. Pri čemer spremembo $(,)$ predstavimo kot $[]$ in spremembo $(, a)$ kot $[a]$.

Zdaj bomo predpostavili, da smo na začetku izbrali možnost 1).

Če želim za niz '1100' ugotoviti zgolj, ali je sprejemljiv niz, bi izbrali navadno branje niza in rezultat v terminalu bi zgledal takole :
```plaintext
Opozorilo : če uporabljate že implementiran avtomat in če želite vnesti niz 'niz', prosim vnesit niz '<' + 'niz' + '>'.
1) izpiši avtomat
2) preberi niz
3) Vnesi niz ter po korakih spremljaj, kako avtomat sprejema niz
> 2
Trenutno stanje :
qi
Trenutni sklad :
$
Vnesi niz > <1100>
Trenutno stanje :
qf
Trenutni sklad :
$
Niz je bil sprejet
Avtomat se bo zdaj resetiral.
```

Opozorilo, da se bo avtomat resetiral pomeni le, da se bo stanje na skladu vrnilo na prvotno stanje ter, da se trenutno stanje pomakne nazaj na začetno stanje.

Sledi še primer uporabe v primeru, ko želimo iterativno brati niz:
```plaintext
Opozorilo : če uporabljate že implementiran avtomat in če želite vnesti niz 'niz', prosim vnesit niz '<' + 'niz' + '>'.
1) izpiši avtomat
2) preberi niz
3) Vnesi niz ter po korakih spremljaj, kako avtomat sprejema niz
> 3
Trenutno stanje :
qi
Trenutni sklad :
$
Vnesi niz > <1100>
Trenutno stanje :
q1
Trenutni sklad :
$
Vnesi niz > 1100>
Trenutno stanje :
q1
Trenutni sklad :
1$
Vnesi niz > 100>
Trenutno stanje :
q1
Trenutni sklad :
11$
Vnesi niz > 00>
Trenutno stanje :
q0
Trenutni sklad :
1$
Vnesi niz > 0>
Trenutno stanje :
q0
Trenutni sklad :
$
Vnesi niz > >
Trenutno stanje :
qf
Trenutni sklad :
$
Vnesi niz > 
Trenutno stanje :
qf
Trenutni sklad :
$
Niz je bil sprejet
Avtomat se bo zdaj resetiral.
```
Seveda si pa tudi lahko ogledamo naš avtomat : 
```plaintext
Opozorilo : če uporabljate že implementiran avtomat in če želite vnesti niz 'niz', prosim vnesit niz '<' + 'niz' + '>'.
1) izpiši avtomat
2) preberi niz
3) Vnesi niz ter po korakih spremljaj, kako avtomat sprejema niz
> 1
Trenutno stanje :
qi
Trenutni sklad :
$
Avtomat :
Seznam vseh stanj : 
q0 | q1 | qf | qi |  
Začetno stanje:
qi
Seznam sprejemnih stanj : 
qf |  
Seznam prehodov :
 
q0  >  $  qf   na sklad :  [ $  ] 
q0  0  1  q0   na sklad :  [ ] 
q1  0  1  q0   na sklad :  [ ] 
q1  1  1  q1   na sklad :  [ 1  1  ] 
q1  1  $  q1   na sklad :  [ 1  $  ] 
qi  <  $  q1   na sklad :  [ $  ] 
Seznam sklada : 
$ 
Posebni znak : 
$
Trenutno stanje :
qi
Trenutni sklad :
$
```

## Implementacija
Na tem mestu naj opozorimo, da naša implementacija predpostavlja, da se sklad nikdar ne popolnooma sprazni. Znak, ki je na začetku na dnu sklada, vedno ostane na skladu. 

### Struktura datotek

Pomembna mapa je mapa 'src', ki kateri sta mapi 'definicije' in 'tekstoVmesnik'.

V mapi 'definicije' so .ml datoteke, ki katerih je implementiran skladovni avtomat. Ta mapa je sestavljena iz sledečih .ml datotek.

### `avtomat.ml`

Tu je implementiran skladovni avtomat. Poleg tega so priložene še pomožne funkcije za delo s skladovnimi avtomati. Podana je tudi implementacija zgornjega primera. Poleg tega so spisane funkcije, ki pomagajo pri interaktivnem sestavljanju svojega skladovnega avtomata. 
Avtomat predstavimo s sledečim zapisnim tipom : 
```ocaml
type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  sprejemna_stanja : stanje list;
  prehodi : (stanje * char * char * stanje * (char list)) list;
  sklad : sklad;
}
```
Tip stanje je implementiran v stanje.ml, tip sklad pa v sklad.ml.

Sledeča funkcija je najpomembnejša za samo uporabo skladdovnega avtomata : 
```ocaml
val preberi_niz : t -> Stanje.t ->string -> (t * Stanje.t * (char) option) option
```
Ta sprejme skladovni avtomat, neko začetno stanje ter niz.  Vrne trojico 
```ocaml
Some (avtomat', stanje', Some vrh)
```
ali pa None. Avtomat' je spremenjen avtomat po prebranem nizu (spremeni se mu stanje na skladu), stanje' je končno stanje ter Some vrh je char option type, ki predsavlja vrh končnega sklada. 

Funkcija, ki omogoča grajenje svojega avtomata je sledeča : 
```ocaml
val make_custom_avtomat : unit -> t
```
Izhodiščni primer je podan v sledeči spremenljivki : 
```ocaml
val n_enk_n_nicel : t
```

### `sklad.ml`

V tej datoteki je implementiran sklad, ki ga dodamo tipe avtomata v datoteki avtomat.ml.
Sklad je predstavljen s sledečim tipom : 
```ocaml
type t = {seznam_sklada : char list; special : char;}
```
Seznam sklada predsavlja intuitivno predstavo sklada. Je char list, pri čemer je prvi znak v seznamu vrh sklada, zadnji element pa dno. 'special' predstavlja posebni znak, ki je na dnu sklada. V našem primeru je to znak $z$, v sami implementaciji pa je to znak za ameriški dolar. Poleg definicije tipa so v tej datoteki implementirane osnovne funkcije, ki smo jih potrebovali pri nadaljni implementaciji in delu z avtomatom in njegovim skladom. 

### `stanje.ml`

V tej datoteki je implementiran tip stanja, ki služi kot nepogrešljiv del tipe avtomata v datoteki avtomat.ml.

Stanje je predstavljeno s sledečim tipom : 
```ocaml
type t = { oznaka : string }
```
Je preprost zapisni tip z zgolj enim poljem. To polje predstavlja ime stanje.

V mapi ''tekstovniVmesnik' je le ena .ml datoteka, in sicer 'tekstovniVmesnik.ml'.

### `tekstovniVmesnik.ml`
V mapi ''tekstovniVmesnik' je le ena .ml datoteka, in sicer 'tekstovniVmesnik.ml'.

V tej datoteki so celovito zbrane najpomembnejše funkcije. Začnimo pa s samo definicijo model : 
```ocaml
type model = {
  avtomat : t;
  stanje_avtomata : Stanje.t;
  stanje_vmesnika : stanje_vmesnika;
}
```
Avtomat je kajpak tip avtomata iz skripte avtomat.ml, stanje_avtomata pa tip stanja iz skripte stanje.ml. Novost je le stanje_vmesnika, ki pa je vsotni tip z določenim številom možnih stanj. 

Funkcija loop
```ocaml
let rec loop model
```
Nam omogoča branje nizov.
Funkcija main 
```ocaml
let rec main ()
```
Pa nam omogoča izbiro avtomata oziroma njegovo izgradnjo ter nadaljnjo uporabo.
