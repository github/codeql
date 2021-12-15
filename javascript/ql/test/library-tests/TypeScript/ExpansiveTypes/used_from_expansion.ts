import * as dummy from "./dummy";

interface BeforeX {
  x: number;
}

interface ExpansiveX<T> {
  a: BeforeX;
  x: ExpansiveX<T[]>;
  b: BeforeX;
}

interface AfterX {
  x: string;
}
