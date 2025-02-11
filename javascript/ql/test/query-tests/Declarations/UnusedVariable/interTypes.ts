import { Foo, Bar } from "somewhere"; // $ TODO-SPURIOUS: Alert

type FooBar<T> =
  T extends [infer S extends Foo, ...unknown[]]
      ? S
      : never;
