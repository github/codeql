import { Foo } from "./foo.interface";

export class FooImpl extends Foo {
    fooMethod(x: string) {
        sink(x); // $ hasValueFlow=x
    }
}
