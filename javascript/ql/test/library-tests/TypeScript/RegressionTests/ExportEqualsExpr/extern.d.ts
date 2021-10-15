class Foo {}

declare module 'foo' {
  export = new Foo();
}

declare module 'bar' {
  import * as baz from "baz";
  export = baz;
}

declare module 'baz' {
  export class C {}
}
