import { ExternalType1, externalSymbol } from "esmodule";

function f(arg: ExternalType1) {
  let y = arg.x; // y should be ExternalType2
}

let foo = 5;

let bar: { x: number };

interface InternalType {
  x: number;
  [externalSymbol]: number;
}
let symb = externalSymbol;

