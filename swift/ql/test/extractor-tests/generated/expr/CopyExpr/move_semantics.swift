//codeql-extractor-options: -enable-experimental-move-only

let x = 42
let _ = copy x
let _ = consume x
