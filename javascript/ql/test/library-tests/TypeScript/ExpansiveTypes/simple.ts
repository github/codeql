import * as dummy from "./dummy";

interface Expansive<T> {
  x: Expansive<T[]>;
}
