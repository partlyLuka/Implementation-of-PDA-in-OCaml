type t = { avtomat : Avtomat.t; trak : Trak.t; stanje : Stanje.t }

let pozeni avtomat trak =
  { avtomat; trak; stanje = Avtomat.zacetno_stanje avtomat }

let avtomat { avtomat; _ } = avtomat
let trak { trak; _ } = trak
let stanje { stanje; _ } = stanje

let korak_naprej { avtomat = _avtomat; trak = _trak; stanje = _stanje } =
  if Trak.je_na_koncu _trak then None
  else match (Sklad.vrh (Avtomat.dobi_sklad _avtomat)) with
    | None -> failwith "Sklad se je spraznil. To je nasprotju s pričakovanim vedenjem. Prosim, podrobno preberite navodila za uporabo. Program namreč predpostavlja, da se sklad nikdar ne sprazni"
    | Some v -> 
      let pomik = Avtomat.preberi_znak _avtomat _stanje v (Trak.trenutni_znak _trak) 
      in 
      match pomik with 
      | None -> None
      | Some (avtomat', stanje', _) -> Some ({avtomat=avtomat';
                             trak = Trak.premakni_naprej _trak;
                              stanje = stanje'})

let je_v_sprejemnem_stanju {avtomat =  avtomat'; trak = _ ;stanje = stanje';} =
  Avtomat.je_sprejemno_stanje avtomat' stanje'

let zagnani_n_enk_n_nicel niz = {avtomat = Avtomat.n_enk_n_nicel; trak = Trak.iz_niza niz; stanje =   Avtomat.zacetno_stanje Avtomat.n_enk_n_nicel}