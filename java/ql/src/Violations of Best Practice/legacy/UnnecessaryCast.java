public class UnnecessaryCast {
    public static void main(String[] args) {
        Integer i = 23;
        Integer j = (Integer)i;  // AVOID: Redundant cast
    }
}