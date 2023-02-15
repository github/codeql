package packageA;

public interface Subinterface extends Superinterface, Superinterface2 {
    public static final int nameClash = 1;
    public static void nameClash() {}
    public static void nameClash(int i) {}

    public static class nameClash {}

    // Hides members from supertypes
    public static class HiddenMemberType {}

    public static final int HIDDEN_FIELD = 1;
    public static void hiddenMethod() {}
}
