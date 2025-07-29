class A {
    A(String msg) {
        System.out.println("A: " + msg);
    }
}

class B extends A {
    B(String input) {
        var msg = input.trim().toUpperCase();
        super(msg);
    }
}

class C {
    private final int x;

    C(int x) {
        if (x < 0) throw new IllegalArgumentException();
        super();
        this.x = x;
    }
}

record R(String name, int score) {
    public R(String name) {
        var score = name.length();
        this(name, score);
    }
}

class Outer {
    private final String prefix = "outer";

    class Inner {
        private final String full;

        Inner(String suffix) {
            var combined = prefix + "_" + suffix;
            super();
            this.full = combined;
        }
    }
}
