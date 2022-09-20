package packageA;

public class Superclass {
    public class Inner {}
    public static class StaticNested {
        public static void m() {}
    }

    public static final int STATIC_FIELD = 1;
    
    public static void staticMethod() {}

    public void instanceMethod() {}

    public static class HiddenMemberType {}

    public static final int HIDDEN_FIELD = 1;
    public static void hiddenMethod() {}
}
