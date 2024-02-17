type t = {seznam_sklada : char list; special : char;}
(*Sklad predstavimo kot sezna. Glava seznama predstvalja vrh sklada*)
(*Special predstavlja posebni znak, navadno znak, ki je na dnu sklada, in s katerim inicializiramo sklad*)
let iz_sez_v_sklad list = {seznam_sklada = list; special='$'}

let push element t = {t with seznam_sklada = element :: (t.seznam_sklada)}
(* Na sklad postavimo element 'element' *)

let pop element t = match t.seznam_sklada with 
  | hd :: tl when hd = element -> {t with seznam_sklada = tl}
  | _ -> t
(* Odstranimo element iz vrha sklada, če je to možno *)

let vrh t = match t.seznam_sklada with
  | hd :: _ -> Some hd
  | [] -> None
let get_special t = t.special
let get_seznam_sklada t = t.seznam_sklada

let prazen_sklad = {seznam_sklada = []; special = '$'}

let read_sklad () = 
  print_string "Vnesi natanko en znak, ki želiš, da je na dnu sklada. (Hint : napiši $) >";
  let s = read_line () in 
  let s = String.get s 0 in 
  {seznam_sklada = [s]; special = s}
