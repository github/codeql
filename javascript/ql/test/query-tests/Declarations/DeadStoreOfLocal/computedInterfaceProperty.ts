import { Foo } from "./exportSymbol"

export interface FooMap {
  [Foo]: number;
}

const Bar = "Bar";

export interface BarMap {
  [Bar]: number;
}

const Baz = "Baz";

if (false) {
  Baz;
}

function getBaz(): typeof Baz { return null; }

class C {}

if (false) {
  C;
}

function getC(): C { return null; }
