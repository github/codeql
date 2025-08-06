package packagetwo;

import packageone.*;

public class Source {
    void f() {
        int i = Annotated.f(); // NON_COMPLIANT
        String s = Annotated.m; // NON_COMPLIANT
        AnnotatedClass a = new AnnotatedClass(); // NON_COMPLIANT
        String s1 = Annotated.m1; // COMPLIANT - same package
    }
}
