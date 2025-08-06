package packagetwo;

import packageone.*;

public class Annotated {
    @VisibleForTesting
    static String m;
    @VisibleForTesting
    static protected String m1;

    @VisibleForTesting
    static int f() {
        return 1;
    }
}
