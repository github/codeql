// Adapted from https://github.com/eslint/eslint, which is licensed
// under the MIT license; see file LICENSE.

class B {}
class A1 { }
class A2 { constructor() { } }
class A3 { constructor() { this.b = 0; } }
class A4 { constructor() { this.b(); } }
class A5 extends null { }
class A6 extends null { constructor() { } }
class A7 extends B { }
class A8 extends B { constructor() { super(); } }
class A9 extends B { constructor() { super(); this.c = this.d; } }
class A10 extends B { constructor() { super(); this.c(); } }
class A11 extends B { constructor() { super(); super.c(); } }
class A12 extends B { constructor() { if (true) { super(); } else { super(); } this.c(); } }
class A13 extends B { constructor() { class B extends C { constructor() { super(); this.d = 0; } } super(); } }
class A14 extends B { constructor() { var B = class extends C { constructor() { super(); this.d = 0; } }; super(); } }
class A15 extends B { constructor() { function c() { this.d(); } super(); } }
class A16 extends B { constructor() { var c = function c() { this.d(); }; super(); } }
class A17 extends B { constructor() { var c = () => this.d(); super(); } }
class A18 { b() { this.c = 0; } }
class A19 extends B { c() { this.d = 0; } }
function a() { this.b = 0; }
class A21 extends B { constructor() { if (a) { super(); this.a(); } else { super(); this.b(); } } }
class A22 extends B { constructor() { if (a) super(); else super(); this.a(); } }
class A23 extends B { constructor() { try { super(); } finally {} this.a(); } }
class A24 extends B { constructor(a) { super(); for (const b of a) { this.a(); } } }
class A25 extends B { constructor(a) { for (const b of a) { foo(b); } super(); } }
class A26 extends B { constructor(a) { super(); this.a = a && function(){} && this.foo; } }
class A27 extends Object {
    constructor() {
        super();
        for (let i = 0; i < 0; i++);
        this;
    }
}
class A28 { constructor() { return; this; } }
class A29 extends B { constructor() { return; this; } }

// extra tests
class A44 extends B { constructor() { (() => super())(); this; } }
