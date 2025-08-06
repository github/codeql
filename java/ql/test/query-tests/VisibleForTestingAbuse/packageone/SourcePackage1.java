package packageone;

import packagetwo.Annotated;

public class SourcePackage1 extends Annotated {
    @VisibleForTesting
    public void f() {

        String s1 = Annotated.m1; // $ SPURIOUS: Alert
        String s2 = Annotated.m2; // $ SPURIOUS: Alert

        int i2 = Annotated.fPublic(); // $ SPURIOUS: Alert
        int i3 = Annotated.fProtected(); // $ SPURIOUS: Alert

        Runnable lambda = () -> {
            String lambdaS1 = Annotated.m1; // $ SPURIOUS: Alert
            String lambdaS2 = Annotated.m2; // $ SPURIOUS: Alert
            int lambdaI2 = Annotated.fPublic(); // $ SPURIOUS: Alert
            int lambdaI3 = Annotated.fProtected(); // $ SPURIOUS: Alert
        };
    }
}
