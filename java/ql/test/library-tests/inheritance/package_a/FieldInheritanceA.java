// See https://docs.oracle.com/javase/specs/jls/se17/html/jls-8.html#jls-8.3

package package_a;

public class FieldInheritanceA {
    private int privateField;
    private static int privateStaticField;

    int packagePrivateField;
    static int packagePrivateStaticField;

    protected int protectedField;
    protected static int protectedStaticField;

    public int publicField;
    public static int publicStaticField;

    private static class ClassWithPrivate {
        private int i;
        private static int staticI;
    }
    private class ExtendingClassWithPrivate extends ClassWithPrivate {}

    private interface InterfaceWithPublic {
        int staticI = 1;
    }
    private interface OtherInterfaceWithPublic {
        int staticI = 1;
    }
    private static class ClassWithPublic {
        public int i;
        public static int staticI;
    }

    // Should inherit all fields called staticI
    private class InheritingClashing extends ClassWithPublic implements InterfaceWithPublic, OtherInterfaceWithPublic {}

    private static class HidingField extends ClassWithPublic {
        // Whether fields are static or not does not make a difference
        public static int i;
        public int staticI;
    }
    private static class ExtendingHidingField extends HidingField {}
    private static class HidingTransitiveField extends ExtendingHidingField {
        public int i;
        public static int staticI;
    }

    private static class HidingWithDifferentType extends ClassWithPublic {
        private String i;
        private static String staticI;
    }

    // Has subclass in FieldInheritanceOtherA
    static class PrivateHidingField extends ClassWithPublic {
        private String i;
        private static String staticI;
    }
}
