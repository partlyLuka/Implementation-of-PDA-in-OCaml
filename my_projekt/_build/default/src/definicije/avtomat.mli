type t
val special_znak : char
val prazen_avtomat : Stanje.t -> Sklad.t -> t
val dodaj_nesprejemno_stanje : Stanje.t -> t -> t
val dodaj_sprejemno_stanje : Stanje.t -> t -> t
val dodaj_prehod : Stanje.t -> char -> char -> Stanje.t -> char list -> t -> t
val prehodna_funkcija : t -> Stanje.t -> char -> char -> (Stanje.t * char list) option
val zacetno_stanje : t -> Stanje.t
val show_zacetno_stanje : t -> string
val seznam_stanj : t -> Stanje.t list
val show_seznam_stanj : t -> string list
val seznam_prehodov : t -> (Stanje.t * char * char * Stanje.t * char list) list
val show_seznam_prehodov : t -> (string * char * char * string * char list) list
val dobi_sklad : t -> Sklad.t
val dobi_seznam_sklada : t -> char list
val dobi_special_char : t -> char
val je_sprejemno_stanje : t -> Stanje.t -> bool
val preberi_znak : t -> Stanje.t -> char -> char -> (t * Stanje.t * (char) option) option
val preberi_niz : t -> Stanje.t ->string -> (t * Stanje.t * (char) option) option
val n_enk_n_nicel : t
val restart_avtomat : t -> t
val read_dodaj_sprejemno_stanje : t -> t 
val read_dodaj_nesprejemno_stanje : t -> t
val read_dodaj_prehod : t -> t
val seznam_sprejemnih_stanj : t -> Stanje.t list
val show_seznam_sprejemnih_stanj : t -> string list 
val make_custom_empty_avtomat : unit -> t 
val modify_avtomat : t -> t
val make_custom_avtomat : unit -> t
val izpisi_prehod : string * char * char * string * char list -> unit
val show_avtomat : t -> unit


