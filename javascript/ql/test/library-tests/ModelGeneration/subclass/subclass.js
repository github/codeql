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

// Test case where subclass chain goes through an internal class
class InternalMidClass extends A {}

export class ExposedMidSubClass extends InternalMidClass {
    m() {}
}
