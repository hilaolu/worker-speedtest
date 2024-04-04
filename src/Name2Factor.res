let unitFactors = unit => {
  switch unit->String.slice(~start=0, ~end=1)->String.toUpperCase {
  | "B" => Some(1)
  | "K" => Some(1024)
  | "M" => Some(1024 * 1024)
  | "G" => Some(1024 * 1024 * 1024)
  | _ => None
  }
}

let filename2length = name => {
  let match = %re("/(\d+)([A-Za-z]+)/")->Js.Re.exec_(name)

  match
  ->Option.map(Js.Re.captures(_))
  ->Option.flatMap(matches =>
    switch matches {
    | [_, Value(num), Value(unit)] =>
      switch (unit->unitFactors, num->Int.fromString) {
      | (Some(factor), Some(n)) => Some(n * factor)
      | _ => None
      }
    | _ => None
    }
  )
}

let name2factor = name => {
  let filename = name->String.split(".")
  filename[0]->Option.flatMap(filename2length)
}
