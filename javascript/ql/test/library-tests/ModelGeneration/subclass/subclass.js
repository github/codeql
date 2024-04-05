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

// TODO: needs to emit type model: [upstream.Type; (subclass).D.prototype; ""]
// The getAValueReachableFromSource() logic does not handle the base class -> instance step
export class D extends upstream.Type {
    d() {}
}
