interface MyInterface {
  foo();
  bar(x: number): string;
  field: number;
}

namespace Foo {
  export interface I {
    bar();
  }
}
