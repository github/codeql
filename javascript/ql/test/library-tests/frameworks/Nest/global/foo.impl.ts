import { Foo , Foo2 } from "./foo.interface";

export class FooImpl extends Foo {
    fooMethod(x: string) {
        sink(x); // $ hasValueFlow=x
    }
}

export class Foo2Impl extends Foo2 {
    fooMethod(x: string) {
        sink(x); // $ hasValueFlow=x
    }
}

export class Foo3Impl extends Foo2 {
    fooMethod(x: string) {
        sink(x); // $ hasValueFlow=x
    }
}