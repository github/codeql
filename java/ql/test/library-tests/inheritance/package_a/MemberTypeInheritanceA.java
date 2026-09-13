// See https://docs.oracle.com/javase/specs/jls/se17/html/jls-8.html#jls-8.5

package package_a;

public class MemberTypeInheritanceA {
    private class PrivateClass {
        private class Nested {}
    }
    private class ExtendingPrivateClass extends PrivateClass {}

    private interface PrivateInterface {}

    class PackagePrivateClass {}
    interface PackagePrivateInterface {}

    protected class ProtectedClass {}
    protected interface ProtectedInterface {}

    public class PublicClass {}
    public static class PublicStaticClass {}
    public interface PublicInterface {
        public static class Nested {}
    }

    private interface ExtendingPublicInterface extends PublicInterface {}
    private interface ExtendingExtendingPublicInterface extends ExtendingPublicInterface {}
    private class ImplementingPublicInterface implements PublicInterface {}

    private interface OtherInterface {
        public static class Nested {}
    }
    private static class OtherClass {
        public static class Nested {}
    }
    // Should inherit all classes called Nested
    private static class InheritingClashing extends OtherClass implements PublicInterface, OtherInterface {}

    private interface HidingNestedClass extends OtherInterface {
        public interface Nested {}
    }
    private interface ExtendingHidingNestedClass extends HidingNestedClass {}
    private interface HidingTransitiveNestedClass extends ExtendingPublicInterface {
        public interface Nested {}
    }

    // Has subclass in MemberTypeInheritanceOtherA
    static class HidingNestedClassPrivate implements OtherInterface {
        private interface Nested {}
    }

    private class WithLocalTypes {
        // Local and anonymous types are not inherited

        {
            class LocalClass {}
        }

        public static final Object o = new Object() {};

        public void m() {
            class LocalClass {}
            interface LocalInterface {}
            record LocalRecord() {}
        }
    }
    private class ExtendingWithLocalTypes extends WithLocalTypes {}
}
