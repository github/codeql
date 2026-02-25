import 'dummy';

function t1() {
    class FieldParam {
        constructor(public field: any) {
            this.field.foo(source('t1'));
        }
    }
    class C {
        foo(x: any) {
            sink(x); // $ hasValueFlow=t1
        }
    }
    new FieldParam(new C());
}
