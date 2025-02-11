// Adapted from https://github.com/eslint/eslint, which is licensed
// under the MIT license; see file LICENSE.

class B1 {}
class A30 extends B1 { constructor() { this.c = 0; } } // $ TODO-SPURIOUS: Alert
class A31 extends B1 { constructor() { this.c(); } } // $ TODO-SPURIOUS: Alert
class A32 extends B1 { constructor() { super.c(); } } // $ TODO-SPURIOUS: Alert
class A33 extends B1 { constructor() { this.c = 0; super(); } } // $ TODO-SPURIOUS: Alert
class A34 extends B1 { constructor() { this.c(); super(); } } // $ TODO-SPURIOUS: Alert
class A35 extends B1 { constructor() { super.c(); super(); } } // $ TODO-SPURIOUS: Alert
class A36 extends B1 { constructor() { super(this.c); } } // $ TODO-SPURIOUS: Alert
class A37 extends B1 { constructor() { super(this.c()); } } // $ TODO-SPURIOUS: Alert
class A38 extends B1 { constructor() { super(super.c()); } } // $ TODO-SPURIOUS: Alert
class A39 extends B1 { constructor() { class C extends D { constructor() { super(); this.e(); } } this.f(); super(); } } // $ TODO-SPURIOUS: Alert
class A40 extends B1 { constructor() { class C extends D { constructor() { this.e(); super(); } } super(); this.f(); } } // $ TODO-SPURIOUS: Alert
class A41 extends B1 { constructor() { if (a) super(); this.a(); } } // $ TODO-SPURIOUS: Alert

// the following two cases are not currently detected (even though they should be):
// while `this` is, in both cases, guarded by a `super` call, the call does not complete
// normally, leading to a runtime error
class B2 { constructor() { throw ""; } }
class A42 extends B2 { constructor() { try { super(); } finally { this.a; } } }
class A43 extends B2 { constructor() { try { super(); } catch (err) { } this.a; } }

class A44 extends B1 {
    constructor() {
        this.p1 = 0;
        this.p2 = 0;
    }
}
