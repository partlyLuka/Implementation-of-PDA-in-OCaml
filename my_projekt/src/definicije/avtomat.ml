type stanje = Stanje.t
type sklad = Sklad.t 
let special_znak = '$'
type t = {
  stanja : stanje list;
  zacetno_stanje : stanje;
  sprejemna_stanja : stanje list;
  prehodi : (stanje * char * char * stanje * (char list)) list;
  sklad : sklad;
}

let prazen_avtomat zacetno_stanje prazen_sklad =
  {
    stanja = [ zacetno_stanje ];
    zacetno_stanje = zacetno_stanje;
    sprejemna_stanja = [];
    prehodi = [];
    sklad = prazen_sklad;
  }

let dodaj_nesprejemno_stanje stanje avtomat =
  { avtomat with stanja = stanje :: avtomat.stanja }

let dodaj_sprejemno_stanje stanje avtomat =
  {
    avtomat with
    stanja = stanje :: avtomat.stanja;
    sprejemna_stanja = stanje :: avtomat.sprejemna_stanja;
  }

let dodaj_prehod stanje1 znak vrh_sklada stanje2 dodatek_k_skladu avtomat =
  { avtomat with prehodi = (stanje1, znak, vrh_sklada, stanje2, dodatek_k_skladu) :: avtomat.prehodi }

let prehodna_funkcija avtomat stanje1 znak vrh_sklada =
  match 
    List.find_opt
      (fun (stanje1', znak', vrh_sklada', _, _) ->
        stanje1' = stanje1 && znak' = znak && vrh_sklada' = vrh_sklada )
        avtomat.prehodi 
      with 
        | None -> None
        | Some (_, _, _, stanje2, dodatek_k_skladu) -> Some ((stanje2, dodatek_k_skladu))


let zacetno_stanje avtomat = avtomat.zacetno_stanje
let show_zacetno_stanje avtomat = Stanje.v_niz avtomat.zacetno_stanje
let seznam_stanj avtomat = avtomat.stanja
let show_seznam_stanj avtomat = List.map (Stanje.v_niz) avtomat.stanja
let seznam_sprejemnih_stanj avtomat = avtomat.sprejemna_stanja
let show_seznam_sprejemnih_stanj avtomat = List.map (Stanje.v_niz) avtomat.sprejemna_stanja
let seznam_prehodov avtomat = avtomat.prehodi
let show_seznam_prehodov avtomat =  List.map (fun (s1, c1, c2, s2, clist) -> (Stanje.v_niz s1), c1, c2, (Stanje.v_niz s2), clist) avtomat.prehodi

let izpisi_prehod prehod =
  print_endline " ";
  let str1, c1, c2, str2, clist = prehod in 
  let aux s = print_string (s ^ "  ") in 
  aux str1;
  aux (String.make 1 c1);
  aux (String.make 1 c2);
  aux str2;
  print_string " na sklad :  [ ";
  List.iter (fun x -> aux (String.make 1 x)) clist;
  print_string "]"

let dobi_sklad avtomat = avtomat.sklad 
let dobi_seznam_sklada avtomat = Sklad.get_seznam_sklada (dobi_sklad avtomat)
let dobi_special_char avtomat = Sklad.get_special avtomat.sklad

let je_sprejemno_stanje avtomat stanje =
  List.mem stanje avtomat.sprejemna_stanja

let preberi_znak avtomat q vrh_sklada znak =
  match (prehodna_funkcija avtomat q znak vrh_sklada) with
  (*Možna dejanja na skladu so : vrh_sklada popnemo oz. odstranimo*)
  (*Sklad ostane nespremenjen*)
  (*Vrh sklada zamenjamo, tj. vrh popnemo in pushenmo novi element*)
  (*Na sklad pushnemo nov element.*)  
    | None -> None
    | Some (stanje2, []) -> (*popnemo vrh sklada*)
      Some (({avtomat with sklad = (Sklad.pop vrh_sklada avtomat.sklad)}, stanje2, Sklad.vrh ((Sklad.pop vrh_sklada avtomat.sklad))))
    | Some (stanje2, [x]) when x = vrh_sklada -> (*Sklad se ne spremeni*)
      Some ((avtomat, stanje2, Sklad.vrh (avtomat.sklad)))
    | Some ((stanje2, [x])) -> (*Iz sklada popnemo vrh in pushnemo x*)
      let popped_sklad = Sklad.pop vrh_sklada avtomat.sklad in 
      let pushed_sklad = Sklad.push x popped_sklad in 
      Some (({avtomat with sklad = pushed_sklad}, stanje2, Sklad.vrh pushed_sklad))
    | Some ((stanje2, y :: x :: [])) when x = vrh_sklada -> (*na sklad pushnemo y*)
      let pushed_sklad = Sklad.push y avtomat.sklad in 
      Some (({avtomat with sklad = pushed_sklad}, stanje2, Sklad.vrh pushed_sklad))
    | _ -> None 

let preberi_niz avtomat q niz = 
  let f triple z' = match triple with
    | None -> None
    | Some (_, _, None) -> (*Če se je nekako zgodilo, da se je sklad spraznil, vrnemo None*)
      None
    | Some (a', q', Some v') -> preberi_znak a' q' v' z' in 
  niz |> String.to_seq |>
  Seq.fold_left f (Some (avtomat, q, Some (special_znak)))
let restart_avtomat avtomat = {avtomat with sklad = (Sklad.iz_sez_v_sklad ['$'])}
let n_enk_n_nicel =
  let qi = Stanje.iz_niza "qi" (*q initial*)
  and q1 = Stanje.iz_niza "q1" (*q1 bere enke*)
  and q0 = Stanje.iz_niza "q0" (*q0 bere ničle*)
  and qf = Stanje.iz_niza "qf" (*qf je final_state (hopefully)*)
  and initial_stack = (Sklad.iz_sez_v_sklad ['$']) in
  prazen_avtomat qi initial_stack 
  |> dodaj_sprejemno_stanje qf
  |> dodaj_nesprejemno_stanje q1 |> dodaj_nesprejemno_stanje q0
  |> dodaj_prehod qi '<' '$' q1 ['$'] (*prvi znak je poseben, predstavlja začetek niza, pomaknemo se iz začetnega stanja v stanje, v katerem na sklad nanašama enke*)
  |> dodaj_prehod q1 '1' '$' q1 ['1'; '$']
  |> dodaj_prehod q1 '1' '1' q1 ['1'; '1'] (*nadaljujemo s pushanjem enke*)
  |> dodaj_prehod q1 '0' '1' q0 [] (*vidimo prvo ničlo. Pomaknemo se na mesto, kjer bomo iz sklada poppali enke, medtem popnemo prvo enko iz sklada*) 
  |> dodaj_prehod q0 '0' '1' q0 [] (*popnemo najvišjo enko iz sklada*)
  |> dodaj_prehod q0 '>' '$' qf ['$'] (*sklad se naj ne bi nikdar spraznil*) 
  (*  q0 's' '$' "qf" ['$']    *)
let read_dodaj_sprejemno_stanje avtomat = 
  print_string "Napiši ime sprejemnega stanja, ki ga želiš dodati. >";
  let str = read_line () in 
  let stanje = Stanje.iz_niza str in 
  dodaj_sprejemno_stanje stanje avtomat 

  let read_dodaj_nesprejemno_stanje avtomat = 
    print_string "Napiši ime sprejemnega stanja, ki ga želiš dodati. >";
    let str = read_line () in 
    let stanje = Stanje.iz_niza str in 
    dodaj_nesprejemno_stanje stanje avtomat 
let read_dodaj_prehod avtomat = 
  print_string "Najprej vnesi stanje, iz katerega se bomo pomaknili. ";
  let stanje1 = Stanje.read_stanje () in 
  print_string "Vnesi znak, ki bi ga sprejeli. >";
  let str = read_line () in 
  let znak = String.get str 0 in
  print_string "Vnesi pričakovano vrednost na vrhu sklada. >";
  let str = read_line () in 
  let vrh_sklada = String.get str 0 in 
  print_string "Vnesi stanje, v katerega bi se naj pomaknili. >";
  let stanje2 = Stanje.read_stanje () in 
  let rec aux () =
    print_endline "pop ) Iz vrha sklada popnemo element";
    print_endline "push ) Na sklad pushnemo element";
    print_endline "null ) Sklad pustimo na miru";
    let r = read_line () in 
    match r with 
      | "push" -> print_string "Napišite kateri element bomo pushnili na sklad. (Dovoljen natanko en znak) >"; read_line ()
      | "pop" -> "pop"
      | "null" -> "null"
      | _ -> print_string "Prosim, napišite enega izmed možnih ukazov." ; aux () in 
  let dodatek_k_skladu = aux () in 
  let dodatek = match String.length dodatek_k_skladu with
    | 1 -> (*pushnili bomo element*) [(String.get dodatek_k_skladu 0); vrh_sklada]
    | 3 -> []
    | 4 ->  [vrh_sklada] 
    | _ -> failwith "Nekaj je šlo zelo narobe" in 
  dodaj_prehod stanje1 znak vrh_sklada stanje2 dodatek avtomat
let show_avtomat avtomat = 
  print_endline "Avtomat :";
  print_endline "Seznam vseh stanj : ";
  (* let aux str = print_endline (str ^ " | ") in *)
  let aux1 str = print_string (str ^ " | ") in 
  List.iter aux1 (show_seznam_stanj avtomat);
  print_endline " ";
  print_endline "Začetno stanje:";
  print_endline (Stanje.v_niz (zacetno_stanje avtomat));
  print_endline "Seznam sprejemnih stanj : ";
  List.iter aux1 (show_seznam_sprejemnih_stanj avtomat);
  print_endline " ";
  print_endline "Seznam prehodov :";
  List.iter izpisi_prehod (show_seznam_prehodov avtomat);
  print_endline " ";
  print_endline "Seznam sklada : ";
  List.iter (fun x -> print_string (String.make 1 x)) (dobi_seznam_sklada avtomat);
  print_endline " ";
  print_endline "Posebni znak : ";
  print_endline (String.make 1 (dobi_special_char avtomat));
  ()

let make_custom_empty_avtomat () = 
  print_string "Najprej začetno stanje.";
  let z_stanje = Stanje.read_stanje () in 
  print_endline "Zdaj bomo določili začetni sklad.";
  let z_sklad = Sklad.read_sklad () in 
  let prazen_a' = prazen_avtomat z_stanje z_sklad in 
  prazen_a'

let rec modify_avtomat avtomat = 
  print_endline "Avtomatu lahko dodamo sprejemno stanje, dodamo nesprejemno stanje ter dodamo prehod.";
  print_endline "1) Če želite dodati nesprejemno stanje";
  print_endline "2) Če želite dodati sprejemno stanje.";
  print_endline "3) Če želite dodati prehod";
  print_endline "4) Če si želite ogledati avtomat oz. mojstrovino v nastajanju";
  print_endline "5) Če ste zadovoljni s svojim avtomatom, ali pa če ste se naveličali.";
  let i = read_line () in 
  match i with 
    | "1" -> modify_avtomat (read_dodaj_nesprejemno_stanje avtomat)
    | "2" -> modify_avtomat (read_dodaj_sprejemno_stanje avtomat)
    | "3" -> modify_avtomat (read_dodaj_prehod avtomat)
    | "4" -> show_avtomat avtomat; modify_avtomat avtomat
    | "5" -> avtomat 
    | _ -> print_endline "Verjamemo, da ima vsak človek svojo voljo, toda v tem avtoritarnem frameworku morate izbrati bodisi 1 bodisi 2 bodisi 3 bodisi 4."; modify_avtomat avtomat 

let rec make_custom_avtomat () = 
  print_string "Ali ste pripravljeni na izjemno avanturo, v kateri bomoo naredili prav SVOJ skladovni avtomat?";
  let i = read_line () in 
  match i with 
    | "Ja" -> 
      make_custom_empty_avtomat () |> modify_avtomat
    | _ -> print_string "Tako izjemnega doživetja res ne smete zamuditi. Raje napišite 'Ja' in pričnite dogodivščino. I will literally not take take anything else as answer."; make_custom_avtomat ()



