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

    public void use(Object o) { }

    public void badNonDefault() {
        String s1 = "";
        s1 = "a";
        use(s1);

        String s2 = "null";
        s2 = "a";
        use(s2);

        Object o = false; // `false` is not the default for Object
        o = true;
        use(o);

        boolean b = true;
        b = false;
        use(b);

        char c1 = '\1';
        c1 = '1';
        use(c1);

        char c2 = '0'; // is not \0
        c2 = '1';
        use(c2);

        double d = 1d;
        d = 0d;
        use(d);

        float f = 1f;
        f = 0f;
        use(f);

        int i = 1;
        i = 0;
        use(i);

        long l = 1L;
        l = 0L;
        use(l);
    }

    // Ignore if stored value is default value
    public void goodDefault() {
        String s = null;
        s = "a";
        use(s);

        boolean b = false;
        b = true;
        use(b);

        char c1 = '\0';
        c1 = '1';
        use(c1);

        char c2 = 0;
        c2 = 1;
        use(c2);

        double d1 = 0d;
        d1 = 1d;
        use(d1);

        double d2 = '\0';
        d2 = 1;
        use(d2);

        float f1 = 0f;
        f1 = 1f;
        use(f1);

        float f2 = 0;
        f2 = 1;
        use(f2);

        int i1 = 0;
        i1 = 1;
        use(i1);

        int i2 = '\0';
        i2 = '1';
        use(i2);

        long l1 = 0L;
        l1 = 1L;
        use(l1);

        long l2 = 0;
        l2 = 1;
        use(l2);
    }

    // ensure extraction of java.lang.RuntimeException
    public void noop() throws RuntimeException { }
}
