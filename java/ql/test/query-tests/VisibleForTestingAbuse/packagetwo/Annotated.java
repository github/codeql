package packagetwo;

import packageone.*;

public class Annotated {
    @VisibleForTesting
    static String m;
    @VisibleForTesting
    static protected String m1;
    @VisibleForTesting
    static public String m2;
    @VisibleForTesting
    static private String m3;

    @VisibleForTesting
    static int f() {
        return 1;
    }

    @VisibleForTesting
    static private int fPrivate() {
        return 1;
    }

    @VisibleForTesting
    static public int fPublic() {
        return 1;
    }

    @VisibleForTesting
    static protected int fProtected() {
        return 1;
    }

    private static void resetPriorities() {
        String priority = m;
        String priority1 = m1;
        String priority2 = m2;
        String priority3 = m3;

        int result = f();
        int resultPrivate = fPrivate();
        int resultPublic = fPublic();
        int resultProtected = fProtected();
    }

    private static void resetPriorities2() {
        Runnable task = () -> {
            String priority = m; // $ SPURIOUS: Alert
            String priority1 = m1; // $ SPURIOUS: Alert
            String priority2 = m2; // $ SPURIOUS: Alert
            String priority3 = m3;

            int result = f(); // $ SPURIOUS: Alert
            int resultPrivate = fPrivate();
            int resultPublic = fPublic(); // $ SPURIOUS: Alert
            int resultProtected = fProtected(); // $ SPURIOUS: Alert
        };
        task.run();
    }

    private static class InnerClass {
        void useVisibleForMembers() {
            String field = m; // $ SPURIOUS: Alert
            String field1 = m1;
            String field2 = m2;
            String field3 = m3;

            int method = f(); // $ SPURIOUS: Alert
            int methodPrivate = fPrivate();
            int methodPublic = fPublic();
            int methodProtected = fProtected();
        }
    }
}
