open Definicije
open Avtomat

type stanje_vmesnika =
  | SeznamMoznosti
  | IzpisAvtomata
  | BranjeNiza
  | BranjeNizaIter
  | RezultatPrebranegaNiza
  | OpozoriloONapacnemNizu
  | RestartModel
  
type model = {
  avtomat : t;
  stanje_avtomata : Stanje.t;
  stanje_vmesnika : stanje_vmesnika;
}

type msg = PreberiNiz of string | PreberiNizIter of string |ZamenjajVmesnik of stanje_vmesnika

let izpisi_model model = 
  print_endline "Trenutno stanje :";
  print_endline (Stanje.v_niz (model.stanje_avtomata));
  print_endline "Trenutni sklad :";
  List.iter print_char (dobi_seznam_sklada (model.avtomat));
  print_endline ""
let update model = function
  | PreberiNiz str -> ( 
      match preberi_niz model.avtomat model.stanje_avtomata str with
      | None -> { model with stanje_vmesnika = OpozoriloONapacnemNizu }
      | Some (a', s', _) ->
          {
           avtomat = a';
           stanje_avtomata = s';
           stanje_vmesnika = RezultatPrebranegaNiza; 
          }
          ) 
  | PreberiNizIter str when (String.length str) = 0 -> {model with stanje_vmesnika = RezultatPrebranegaNiza}
  | PreberiNizIter str ->  (
    let hd = String.get str 0 in
    (*let tl = String.sub str 1 ((String.lenght str) - 1) in *)
    match Sklad.vrh (dobi_sklad model.avtomat) with
    | None -> print_endline "Sklad se je popolnoma spraznil. Nekaj je šlo zelo narobe. Če berete to sporočilo ste najbrž totalno cracknili celo mojo projektno nalogo. Za nagrado vam prepuščam sledeča filozofska vprašanja : 1. Ali je razvoj osebne filozofije moralnega relativizma edini način za preživetja v kompleksnem etičnem svetu ali pa je to zgolj izgovor za grešenje?, 2. Je idealizacije utopije stanovitna prvina redkih posameznikov ali zgold otroška, morda patološka tendenca človeka, ki se znajde v brezupju in bedi? in 3. How does the moon work and why can we eat salad, but not grass?." ; failwith "Two roads diverge in a yellow wood, and I, I took the one least traveled by. - Robert Frost. Najini poti se tako tudi ločujeta. Adijo!"
    | Some vrh -> 
    match preberi_znak model.avtomat model.stanje_avtomata vrh hd with
    | None -> { model with stanje_vmesnika = OpozoriloONapacnemNizu }
    | Some (a', s', _) ->
        {
         avtomat = a';
         stanje_avtomata = s';
         stanje_vmesnika = BranjeNizaIter; 
        }
        ) 
  | ZamenjajVmesnik RestartModel -> {avtomat = restart_avtomat model.avtomat; stanje_avtomata = zacetno_stanje model.avtomat; stanje_vmesnika = RestartModel}
  | ZamenjajVmesnik stanje_vmesnika -> { model with stanje_vmesnika }    
let rec izpisi_moznosti () =
  print_endline "Opozorilo : če uporabljate že implementiran avtomat in če želite vnesti niz 'niz', prosim vnesit niz '<' + 'niz' + '>'.";
  print_endline "1) izpiši avtomat";
  print_endline "2) preberi niz";
  print_endline "3) Vnesi niz ter po korakih spremljaj, kako avtomat sprejema niz";
  print_string "> ";
  match read_line () with
  | "1" -> ZamenjajVmesnik IzpisAvtomata
  | "2" -> ZamenjajVmesnik BranjeNiza
  | "3" -> ZamenjajVmesnik BranjeNizaIter
  | _ ->
      print_endline "** VNESI 1 ALI 2 **";
      izpisi_moznosti ()


let beri_niz _model =
  print_string "Vnesi niz > ";
  let str = read_line () in
  PreberiNiz str

  let beri_niz_iter _model =
    print_string "Vnesi niz > ";
    let str =  (read_line ())  in
    PreberiNizIter str
let izpisi_rezultat model =
  if je_sprejemno_stanje model.avtomat model.stanje_avtomata then
    print_endline "Niz je bil sprejet"
  else 
    print_endline "Niz ni bil sprejet"
let izpisi_restart () = print_endline "Avtomat se bo zdaj resetiral."

let view model =
  match model.stanje_vmesnika with
  | SeznamMoznosti -> izpisi_moznosti ()
  | IzpisAvtomata ->
      show_avtomat model.avtomat;
      ZamenjajVmesnik SeznamMoznosti
  | BranjeNiza -> beri_niz model
  | BranjeNizaIter -> beri_niz_iter model
  | RezultatPrebranegaNiza ->
      izpisi_rezultat model;
      ZamenjajVmesnik RestartModel
  | OpozoriloONapacnemNizu ->
      print_endline "Niz ni veljaven";
      ZamenjajVmesnik RestartModel
  | RestartModel -> 
      izpisi_restart ();
      ZamenjajVmesnik SeznamMoznosti
let init avtomat =
  {
    avtomat;
    stanje_avtomata = zacetno_stanje avtomat;
    stanje_vmesnika = SeznamMoznosti;
  }




let rec loop model =
  match model.stanje_vmesnika with 
    | RestartModel -> 
      let msg = view model in
      let model' = update model msg in
      loop model'
    | OpozoriloONapacnemNizu -> 
      let msg = view model in
      let model' = update model msg in
      loop model'
    | _ -> 
      izpisi_model model;
      let msg = view model in
      let model' = update model msg in
      loop model'

let rec main () =
  print_endline "Pozdravljeni v svetu skladovnih avtomatov!";
  print_endline "Trenutno imate 3 možnosti :";
  print_endline "1) Lahko preizkustie v naprej pripravljen skladovni avtomat, ki preveri, ali je niz oblike 111..10...000, torej ima enako število enk kot ničel in je takšne oblike";
  print_endline "2) Lahko naredit svoj, res SVOJ, skladovni avtomat in ga preizkusite na čisto svojih primerih";
  print_endline "3) Lahko se odrečete užitku preizkuševanja in grajenju skladovnih avtomatov";
  print_endline "Izbira je vaša.";
  let i = read_line () in 
  match i with 
    | "1" -> loop (init n_enk_n_nicel)
    | "2" -> loop (init (make_custom_avtomat ()))
    | "3" -> ()
    | _ -> print_endline "Izberite 1, 2 ali 3"; main ()

let _ = main ()

(*
let _ = loop (init n_enk_n_nicel)
let model = init n_enk_n_nicel;;
let m = update model (PreberiNiz "aa");;
Definicije.Stanje.v_niz m.stanje_avtomata;;
let str = "1100";;
preberi_niz model.avtomat model.stanje_avtomata str;;
let p = function | None -> failwith "lol" | Some (_, x, _) -> x;;
str |> preberi_niz model.avtomat model.stanje_avtomata |> p |> Stanje.v_niz ;;
*)