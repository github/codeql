package packagetwo;

import packageone.*;

public class Source {
    void f() {
        int i = Annotated.f(); // $ Alert
        String s = Annotated.m; // $ Alert
        AnnotatedClass a = new AnnotatedClass(); // $ Alert
        String s1 = Annotated.m1; // COMPLIANT - same package
    }
}
