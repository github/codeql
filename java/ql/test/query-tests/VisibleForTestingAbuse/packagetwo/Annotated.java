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
            String priority = m;
            String priority1 = m1;
            String priority2 = m2;
            String priority3 = m3;

            int result = f();
            int resultPrivate = fPrivate();
            int resultPublic = fPublic();
            int resultProtected = fProtected();
        };
        task.run();
    }

    private static class InnerClass {
        void useVisibleForMembers() {
            String field = m;
            String field1 = m1;
            String field2 = m2;
            String field3 = m3;

            int method = f();
            int methodPrivate = fPrivate();
            int methodPublic = fPublic();
            int methodProtected = fProtected();
        }
    }

    @VisibleForTesting
    static class InnerTestClass {
        @VisibleForTesting
        int getSize() {
            return 42;
        }
        
        @VisibleForTesting
        private String data;
    }
    
    private void useInnerClass() {
        InnerTestClass inner = new InnerTestClass();
        int size = inner.getSize();
        String value = inner.data;
    }
}
