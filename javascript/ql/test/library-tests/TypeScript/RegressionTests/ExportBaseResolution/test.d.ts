declare namespace A.B {
    namespace C {
        interface I { }
    }
    declare var C: number;
    declare interface C { }
}

declare module 'test' {
    export = A.B.C;
}
