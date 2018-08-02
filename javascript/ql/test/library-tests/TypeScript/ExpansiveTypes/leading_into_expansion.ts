import * as dummy from "./dummy";

interface Before {
  x: Expansive<number>;
}

interface Expansive<T> {
  x: Expansive<T[]>;
}

interface After {
  x: Expansive<string>;
}
