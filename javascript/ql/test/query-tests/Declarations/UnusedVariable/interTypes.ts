import { Foo, Bar } from "somewhere"; // OK

type FooBar<T> =
  T extends [infer S extends Foo, ...unknown[]]
      ? S
      : never;
