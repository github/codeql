class NonNullTest {
    final String constantNull = null;
    final String constant = "";

    Object getMaybeNull() {
        return null;
    }

    void notNull() {
        Object temp;
        Object[] r = {
            new Object(),
            new int[0],
            this,
            "",

            Boolean.TRUE,
            Boolean.FALSE,

            1,
            Float.NaN,
            constant,
            (Object) "",
            temp = "",

            getMaybeNull() == null ? "" : new Object(),
            switch(1) {
                case 1 -> "";
                default -> constant;
            }
        };

        Runnable[] functional = {
            this::notNull,
            () -> notNull()
        };

        String s = null;
        String s2 = null;
        r = new Object[] {
            s + s2,
            null + s,
            s += s2,
            (String) null + null
        };

        Object n1 = getMaybeNull();
        // Guarded by null check
        if (n1 != null) {
            r = new Object[] {
                n1
            };
        }

        Object n2 = getMaybeNull();
        // Assigned a non-null value
        n2 = "";
        r = new Object[] {
            n2
        };

        // final variable for which all assigned values are non-null
        final Object n3;
        if (getMaybeNull() == null) {
            n3 = "";
        } else {
            n3 = 1;
        }
        r = new Object[] {
            n3
        };
    }

    void maybeNull(boolean b, int i) {
        Object temp;
        Object[] r = {
            constantNull,
            (Object) null,
            temp = (String) null,
            b ? "" : null,
            switch(i) {
                case 1 -> "";
                default -> null;
            },
            null
        };
    }
}
