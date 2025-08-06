package packagetwo;

import packageone.*;

public class Test {
    void f() {
        // Fields
        String s = Annotated.m; // COMPLIANT
        String s1 = Annotated.m1; // COMPLIANT
        String s2 = Annotated.m2; // COMPLIANT
        // String s3 = Annotated.m3; // Cannot access private field
        
        // Methods
        int i = Annotated.f(); // COMPLIANT
        // int i1 = Annotated.fPrivate(); // Cannot access private method
        int i2 = Annotated.fPublic(); // COMPLIANT
        int i3 = Annotated.fProtected(); // COMPLIANT
        
        // Other class
        AnnotatedClass a = new AnnotatedClass(); // COMPLIANT
        
        // Lambda usage
        Runnable lambda = () -> {
            String lambdaS = Annotated.m; // COMPLIANT
            String lambdaS1 = Annotated.m1; // COMPLIANT
            String lambdaS2 = Annotated.m2; // COMPLIANT
            
            int lambdaI = Annotated.f(); // COMPLIANT
            int lambdaI2 = Annotated.fPublic(); // COMPLIANT
            int lambdaI3 = Annotated.fProtected(); // COMPLIANT
        };
        lambda.run();
    }
}
