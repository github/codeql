package packagetwo;

import packageone.*;

public class Source {
    void f() {
        // Fields
        String s = Annotated.m; // $ Alert
        String s1 = Annotated.m1; // COMPLIANT - same package
        String s2 = Annotated.m2;
        // String s3 = Annotated.m3; // Cannot access private field
        
        // Methods
        int i = Annotated.f(); // $ Alert
        // int i1 = Annotated.fPrivate(); // Cannot access private method
        int i2 = Annotated.fPublic();
        int i3 = Annotated.fProtected();
        
        // Other class
        AnnotatedClass a = new AnnotatedClass(); // $ Alert
        
        // Lambda usage
        Runnable lambda = () -> {
            String lambdaS = Annotated.m; // $ Alert
            String lambdaS1 = Annotated.m1;
            String lambdaS2 = Annotated.m2;
            
            int lambdaI = Annotated.f(); // $ Alert
            int lambdaI2 = Annotated.fPublic();
            int lambdaI3 = Annotated.fProtected();
        };
        lambda.run();
    }
}
