export class A {
    a() {}
}

export class B extends A {
    b() {}
}

export class C extends B {
    c() {}
}

import * as upstream from "upstream-lib";

export class D extends upstream.Type {
    d() {}
}
