import { Foo, Bar, Baz } from "somewhere";

export function f(this: Foo) {}

export class C {
  m(this: Bar) {}
}

export default {
  foo(this: Baz) {}  
}
