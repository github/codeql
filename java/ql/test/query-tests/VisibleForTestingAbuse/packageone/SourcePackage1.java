package packageone;

import packagetwo.Annotated;

public class SourcePackage1 extends Annotated {
    @VisibleForTesting
    public void f() {

        String s1 = Annotated.m1;
        String s2 = Annotated.m2;

        int i2 = Annotated.fPublic();
        int i3 = Annotated.fProtected();

        Runnable lambda = () -> {
            String lambdaS1 = Annotated.m1;
            String lambdaS2 = Annotated.m2;
            int lambdaI2 = Annotated.fPublic();
            int lambdaI3 = Annotated.fProtected();
        };
    }
}
