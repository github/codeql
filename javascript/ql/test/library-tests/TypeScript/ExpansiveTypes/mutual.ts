import * as dummy from "./dummy";

interface ExpansiveA<T> {
  x: ExpansiveB<T[]>;
}

interface ExpansiveB<S> {
  x: ExpansiveA<S>;
}


interface ExpansiveC<T> {
  x: ExpansiveD<T>;
}
interface ExpansiveD<T> {
  x: ExpansiveC<T[]>;
}
