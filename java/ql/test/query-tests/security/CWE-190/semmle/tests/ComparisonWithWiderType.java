public class ComparisonWithWiderType {
    public void testLt(long l) {
        // BAD: loop variable is an int, but the upper bound is a long
        for (int i = 0; i < l; i++) {
            System.out.println(i);
        }

        // GOOD: loop variable is a long
        for (long i = 0; i < l; i++) {
            System.out.println(i);
        }
    }

    public void testGt(short c) {
        // BAD: loop variable is a byte, but the upper bound is a short
        for (byte b = 0; c > b; b++) {
            System.out.println(b);
        }
    }

    public void testLe(int i) {
        // GOOD: loop variable is a long, and the upper bound is an int
        for (long l = 0; l <= i; l++) {
            System.out.println(l);
        }
    }
}