class VarAccess {
    static Nested staticF;
    Nested f;
    Nested[] nesteds;
    static Nested[] staticNesteds;

    class Nested {
        String fInner;
        Nested nested;

        void inner(VarAccess other) {
            // Enclosing field access
            checkSameVarAccess(nesteds, nesteds); // $sameVarAccess
            checkSameVarAccess(VarAccess.this.nesteds, nesteds); // $sameVarAccess
            // Should not match, access of field with other owner
            checkSameVarAccess(other.nesteds, nesteds);
            checkSameVarAccess(other.nesteds, VarAccess.this.nesteds);

            checkSameVarAccess(other.nesteds, other.nesteds); // $sameVarAccess
        }
    }

    // Inner class extending outer
    class NestedExtending extends VarAccess {
        void inner() {
            checkSameVarAccess(f, f); // $sameVarAccess
            checkSameVarAccess(this.f, f); // $sameVarAccess
            checkSameVarAccess(super.f, f); // $sameVarAccess
            checkSameVarAccess(NestedExtending.this.f, f); // $sameVarAccess
            checkSameVarAccess(NestedExtending.super.f, f); // $sameVarAccess
            // Not same; accesses `this.f` and enclosing `f`
            checkSameVarAccess(NestedExtending.super.f, VarAccess.this.f);
            checkSameVarAccess(VarAccess.this.f, f);
        }

        class NestedNested {
            void inner() {
                checkSameVarAccess(NestedExtending.super.f, NestedExtending.this.f); // $sameVarAccess
                checkSameVarAccess(NestedExtending.super.f, NestedExtending.super.f); // $sameVarAccess

                // Not same; access enclosing `VarAccess.f` and `NestedExtending.f`
                checkSameVarAccess(VarAccess.this.f, NestedExtending.this.f);
                checkSameVarAccess(VarAccess.this.f, NestedExtending.super.f);
            }
        }
    }

    void test(VarAccess other) {
        checkSameVarAccess(f, f); // $sameVarAccess
        checkSameVarAccess(f.fInner, f.fInner); // $sameVarAccess
        checkSameVarAccess(f.fInner, f.nested);
        checkSameVarAccess(f.fInner, other.f.fInner);
        checkSameVarAccess(f.nested.nested, f.nested.nested); // $sameVarAccess

        checkSameVarAccess(staticF, staticF); // $sameVarAccess

        // Qualifier should be ignored when accessing static field
        checkSameVarAccess(this.staticF, other.staticF); // $sameVarAccess
        checkSameVarAccess(this.staticF.nested, other.staticF.nested); // $sameVarAccess
        checkSameVarAccess(this.staticNesteds[0].nested, other.staticNesteds[0].nested); // $sameVarAccess

        checkSameVarAccess(other, other); // $sameVarAccess
        checkSameVarAccess(this.nesteds, other.nesteds);
        checkSameVarAccess(VarAccess.this.nesteds, nesteds); // $sameVarAccess
    }

    void testArray(int i) {
        checkSameVarAccess(nesteds[0].nested, nesteds[0].nested); // $sameVarAccess
        checkSameVarAccess(this.nesteds[0].nested, nesteds[0].nested); // $sameVarAccess
        checkSameVarAccess(VarAccess.this.nesteds[0].nested, nesteds[0].nested); // $sameVarAccess

        final int i1 = 0;
        final int i2 = 0;
        // No match when same compile time constants are used
        checkSameVarAccess(nesteds[i1].nested, nesteds[i2].nested);
        checkSameVarAccess(nesteds[1 + 1].nested, nesteds[2].nested);

        checkSameVarAccess(nesteds[i].nested, nesteds[i].nested); // $sameVarAccess
        checkSameVarAccess(nesteds[i].nested, nesteds[0].nested);
        checkSameVarAccess(nesteds[i].nested, nesteds[i + 1].nested);
    }

    // Used in QL test to check var access
    static void checkSameVarAccess(Object a, Object b) {}
}