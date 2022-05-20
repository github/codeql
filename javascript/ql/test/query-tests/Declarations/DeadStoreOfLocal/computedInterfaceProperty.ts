import { Foo } from "./exportSymbol" // OK

export interface FooMap {
  [Foo]: number; // OK
}

const Bar = "Bar"; // OK

export interface BarMap {
  [Bar]: number;
}

const Baz = "Baz"; // OK

if (false) {
  Baz;
}

function getBaz(): typeof Baz { return null; }

class C {} // OK

if (false) {
  C;
}

function getC(): C { return null; }
