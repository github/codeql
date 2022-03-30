import { Foo } from "../foo";

let f = new Foo();
let b = f.bar();


import { Foo as Foo2, type Inter, type Bar } from "../foo";

class Impl implements Inter {
    bar(): Bar {
        return new Foo().bar();
    }
}