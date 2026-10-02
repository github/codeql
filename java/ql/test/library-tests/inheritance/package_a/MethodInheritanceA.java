// See https://docs.oracle.com/javase/specs/jls/se17/html/jls-8.html#jls-8.4.8

package package_a;

import java.util.List;

public class MethodInheritanceA {
    // Constructor is not inherited
    public MethodInheritanceA() {}

    private void privateMethod() {}
    private static void privateStaticMethod() {}

    void packagePrivateMethod() {}
    static void packagePrivateStaticMethod() {}

    protected void protectedMethod() {}
    protected static void protectedStaticMethod() {}

    public void publicMethod() {}
    public static void publicStaticMethod() {}

    private static class ClassWithPrivate {
        // Initializer are not inherited
        {
            System.out.println("init");
        }
        static {
            System.out.println("static init");
        }

        private void m() {}
    }
    private static class ExtendingClassWithPrivate extends ClassWithPrivate {}

    private interface InterfaceWithPrivate {
        private void m() {}
        private static void staticM() {}
        // Static methods are not inherited from interfaces
        public static void publicStaticM() {}
    }
    private interface ExtendingInterfaceWithPrivate extends InterfaceWithPrivate {}
    private class ImplementingInterfaceWithPrivate implements InterfaceWithPrivate {}

    private interface Interface {
        default void d() {}
        void a();
    }
    private interface ExtendingInterface extends Interface {}

    private interface InterfaceWithPublic {
        void m();
    }
    private interface OtherInterfaceWithPublic {
        void m();
    }
    private interface InterfaceWithDefault {
        default void m() {}
    }
    private static abstract class AbstractClassWithPublic {
        public abstract void m();
    }
    private static class ClassWithPublic {
        public void m() {}
    }
    private static class ExtendingClassWithPublic extends ClassWithPublic {}

    // Should inherit all methods called m()
    private abstract class AbstractInheritingClashing extends AbstractClassWithPublic implements InterfaceWithPublic, OtherInterfaceWithPublic, InterfaceWithDefault {}

    // Should only inherit m() from ClassWithPublic
    private class InheritingClashing extends ClassWithPublic implements InterfaceWithPublic, OtherInterfaceWithPublic, InterfaceWithDefault {}

    // Should only inherit concrete method m() from ClassWithPublic, even though it is only
    // transitively inherited
    private class InheritingClashingTransitive extends ExtendingClassWithPublic implements InterfaceWithPublic, OtherInterfaceWithPublic, InterfaceWithDefault {}

    private interface MultipleMethods {
        void m(int i);
        void m(Integer i);
    }
    private interface ExtendingMultipleMethods extends MultipleMethods {
        @Override
        void m(int i);

        // Other method should still be inherited
    }

    private interface Base {
        default void m() {
            System.out.println("base");
        }
    }
    private interface OverridingBase extends Base {
        @Override
        default void m() {
            System.out.println("overridden");
        }
    }

    // Should only inherit OverridingBase.m()
    private static class BaseAndOverride implements OverridingBase, Base {}

    private interface ExtendingOverridingBase extends OverridingBase {}
    // Should only inherit OverridingBase.m()
    private static class BaseAndExtendingOverride implements ExtendingOverridingBase, Base {}

    private class ClassWithParameterized {
        public void m(List<String> l) {}
    }
    private class ClassWithRaw {
        public void m(List raw) {}
    }
    private interface InterfaceWithParameterized {
        void m(List<Integer> l);
    }
    private class InheritingSubsignature extends ClassWithRaw implements InterfaceWithParameterized {}
    private class OverridingSubsignatureRawClass extends ClassWithRaw implements InterfaceWithParameterized {
        @Override
        public void m(List raw) {}
    }
    private class OverridingSubsignatureParameterized extends ClassWithParameterized implements InterfaceWithParameterized {
        @Override
        public void m(List raw) {}
    }
}
