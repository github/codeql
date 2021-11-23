export class Foo {
  bar(): Bar { return new Bar() }
}

export class Bar {}

export interface Inter {
  bar(): Bar;
}