public class A {
    public long ex1(int i, int w1, int w2, int w3, long[][][] bits) {
        long nword = ~0L << i;
        long[][] a2;
        long[] a3;
        if (w1 < 42 && (a2 = bits[w1]) != null
                && (a3 = a2[w2]) != null
                && ((nword = ~a3[w3] & (~0L << i))) == 0L) {
            w3 = 7; w2 = 5; w1 = 3;
            loop: for (; w1 != 42; ++w1) {
                if ((a2 = bits[w1]) != null)
                    for (; w2 != 42; ++w2)
                    {
                        if ((a3 = a2[w2]) != null)
                            for (; w3 != 42; ++w3)
                                if ((nword = ~a3[w3]) != 0)
                                    break loop;
                        w3 = 0;
                    }
                w2 = w3 = 0;
            }
        }
        return (((w1 << 3) + (w2 << 3) + w3) << 3) + nword;
    }

    public void ex2() {
        for (int i = 0; i < 5; i++) {
            int x = 42;
            x = x + 3; // DEAD
        }
    }

    public int ex3(int param) {
        param += 3; // DEAD
        param = 4;
        int x = 7;
        ++x; // DEAD
        x = 10;
        int y = 5;
        y = (++y) + 5; // DEAD (++y)
        return x + y + param;
    }

    public void ex4() {
        boolean exc;
        exc = true; // OK
        try {
            new Object();
            exc = false;
        } finally {
            if (exc) { ex3(0); }
        }
        int x;
        try {
            x = 5; // DEAD
            ex3(0);
            x = 7;
            ex3(x);
        } catch (Exception e) {
        }
        boolean valid;
        try {
            if (ex3(4) > 4) {
                valid = false; // DEAD
            }
            ex3(0);
            valid = true;
        } catch(Exception e) {
            valid = false;
        }
        if (valid) return;
    }

    // ensure extraction of java.lang.RuntimeException
    public void noop() throws RuntimeException { }
}
