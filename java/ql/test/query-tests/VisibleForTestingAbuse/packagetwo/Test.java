package packagetwo;

import packageone.*;

public class Test {
    void f() {
        int i = Annotated.f(); // COMPLIANT
        String s = Annotated.m; // COMPLIANT
        AnnotatedClass a = new AnnotatedClass(); // COMPLIANT
        String s1 = Annotated.m1; // COMPLIANT
    }
}
