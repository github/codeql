package packageA;

public interface Superinterface {
    public static class StaticNested {
        public static void m() {}
    }

    int STATIC_FIELD = 1;

    public static void staticMethod() {}

    default void instanceMethod() {}

    public static class HiddenMemberType {}

    int HIDDEN_FIELD = 1;
    public static void hiddenMethod() {}
}
