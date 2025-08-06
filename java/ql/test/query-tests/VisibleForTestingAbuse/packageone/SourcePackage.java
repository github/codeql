package packageone;

import packagetwo.Annotated;

public class SourcePackage extends Annotated {
    void f() {
        AnnotatedClass a = new AnnotatedClass(); // COMPLIANT - same package
        String s1 = Annotated.m1; // $ Alert
    }
}
