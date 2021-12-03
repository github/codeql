import * as dummy from "./dummy";

class LocalClass<Bar> {}
export class ExportedClass<Bar> {}

let localBar = new LocalClass<number>();
let exportedBar = new ExportedClass<number>();

namespace LocalNamespace {
  export class C<Bar> {}
  let barC = new C<number>();
}
