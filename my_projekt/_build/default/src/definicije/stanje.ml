type t = { oznaka : string }

let iz_niza oznaka = { oznaka }
let v_niz { oznaka } = oznaka

let read_stanje () =
  print_string "Vnesi ime stanja. >";
  let str = read_line () in 
  iz_niza str