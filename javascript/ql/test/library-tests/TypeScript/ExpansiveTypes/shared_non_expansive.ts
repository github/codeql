import * as dummy from "./dummy";

// Box is not expansive by itself but expansions may go "through" it.
interface Box<S> {
  x: S;
}

// A too simple algorithm might classify this as expansive.
interface NonExpansive<T> {
  x: NonExpansive<Box<number>>;
  y: Box<T[]>;
}
