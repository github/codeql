import * as dummy from "./dummy";

class LocalClass<Foo> {}
export class ExportedClass<Foo> {}

let localFoo = new LocalClass<number>();
let exportedFoo = new ExportedClass<number>();

namespace LocalNamespace {
  export class C<Foo> {}
  let fooC = new C<number>();
  
  class InnerC<Foo1> {}
  let innerFoo1 = new InnerC<number>();
}

namespace LocalNamespace {
  class InnerC<Foo2> {}
  let innerFoo2 = new InnerC<number>();  
}
