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
    private interface ExtendingInterfaceWithPublic extends InterfaceWithPublic {}
    private interface OtherInterfaceWithPublic {
        void m();
    }
    private interface InterfaceWithDefault {
        default void m() {}
    }
    private static class ClassWithPublic {
        public void m() {}
    }
    private static abstract class AbstractClassWithPublic {
        public abstract void m();
    }

    // Should inherit all methods called m()
    private abstract class AbstractInheritingClashing extends AbstractClassWithPublic implements InterfaceWithPublic, OtherInterfaceWithPublic, InterfaceWithDefault {}

    // Should only inherit m() from ClassWithPublic
    private class InheritingClashing extends ClassWithPublic implements InterfaceWithPublic, OtherInterfaceWithPublic, InterfaceWithDefault {}

    private interface MulitpleMethods {
        void m(int i);
        void m(Integer i);
    }
    private interface ExtendingMulitpleMethods extends MulitpleMethods {
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

    private static class BaseAndOverride implements OverridingBase, Base {}

    private interface ExtendingOverridingBase extends OverridingBase {}
    /*
     * JLS is imprecise here, it currently says:
     * > There exists no method m' that is a member of the direct superclass type or a direct superinterface type of C
     * 
     * Based on how this code currently behaves it should be "that is a **declared or inherited** member"; otherwise
     * if one does not consider inherited members, in this case one might expect that Base.m() is used when calling m()
     */
    private static class BaseAndExtendingOverride implements ExtendingOverridingBase, Base {}

    private class ClassWithRaw {
        public void m(List raw) {}
    }
    private interface InterfaceWithGeneric {
        void m(List<?> l);
    }
    private class InheritingBoth extends ClassWithRaw implements InterfaceWithGeneric {}
    private class OverridingBoth extends ClassWithRaw implements InterfaceWithGeneric {
        @Override
        public void m(List raw) {}
    }
}
