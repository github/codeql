package packageone;

import packagetwo.Annotated;

public class SourcePackage extends Annotated {
    void f() {
        // Fields - cross-package access (only accessible ones)
        // String s = Annotated.m; // Cannot access package-private from different package
        String s1 = Annotated.m1; // $ Alert
        String s2 = Annotated.m2; // $ Alert
        // String s3 = Annotated.m3; // Cannot access private field
        
        // Methods - cross-package access (only accessible ones)
        // int i = Annotated.f(); // Cannot access package-private from different package
        // int i1 = Annotated.fPrivate(); // Cannot access private method
        int i2 = Annotated.fPublic(); // $ Alert
        int i3 = Annotated.fProtected(); // $ Alert
        
        // Same package class
        AnnotatedClass a = new AnnotatedClass(); // COMPLIANT - same package
        
        // Lambda usage - cross-package (only accessible members)
        Runnable lambda = () -> {
            // String lambdaS = Annotated.m; // Cannot access package-private
            String lambdaS1 = Annotated.m1; // $ Alert
            String lambdaS2 = Annotated.m2; // $ Alert
            
            // int lambdaI = Annotated.f(); // Cannot access package-private
            int lambdaI2 = Annotated.fPublic(); // $ Alert
            int lambdaI3 = Annotated.fProtected(); // $ Alert
        };
        lambda.run();
    }
    String myField1 = Annotated.m1; // $ Alert
    public String myField2 = Annotated.m1; // $ Alert
    private String myField3 = Annotated.m1; // $ Alert
    protected String myField4 = Annotated.m1; // $ Alert
}
