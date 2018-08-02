import * as dummy from "./dummy";

interface Expand<T> {
  x: Box<Expand<T[]>>
}

// Box is not expansive by itself but expansions may go "through" it.
interface Box<S> {
  x: S;
}
