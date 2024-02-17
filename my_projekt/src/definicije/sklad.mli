type t 

val iz_sez_v_sklad : char list -> t 
val push : char -> t -> t
val pop : char -> t -> t
val vrh : t -> char option 
val get_special : t -> char
val get_seznam_sklada : t -> char list
val prazen_sklad : t
val read_sklad : unit -> t 