import { Foo, Bar } from "somewhere"; // $ Alert

type FooBar<T> =
  T extends [infer S extends Foo, ...unknown[]]
      ? S
      : never;
