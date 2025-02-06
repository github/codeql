import { Foo, Bar } from "somewhere";

type FooBar<T> =
  T extends [infer S extends Foo, ...unknown[]]
      ? S
      : never;
