import * as dummy from "./dummy";

// The expansive edge may be preceded by non-expansive edges.

interface ExpansiveA<T> {
  a: ExpansiveB<T>;
  b: ExpansiveB<number>;
  x: ExpansiveB<T[]>;
}

interface ExpansiveB<S> {
  x: ExpansiveA<S>;
}


interface ExpansiveC<T> {
  x: ExpansiveD<T>;
}

interface ExpansiveD<T> {
  a: ExpansiveC<T>;
  b: ExpansiveC<number>;
  x: ExpansiveC<T[]>;
}
