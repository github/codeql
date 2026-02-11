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
        private String full;

        Inner(String suffix) {
            var combined = prefix + "_" + suffix;
            super();
            this.full = combined;
        }
    }
}

class D {
    private final String value;
    private final int length;

    D(String input) {
        var processed = input.toLowerCase();
        value = processed;
        this.length = processed.length();
        super();
    }
}

class E extends A {
    private boolean isValid;
    private String processed;

    E(String data) {
        var temp = data != null ? data.trim() : "";
        this.processed = temp;
        isValid = !temp.isEmpty();
        super(temp);
    }
}

class F {
    private int x;
    private final int y;
    private int sum;

    F(int a, int b) {
        x = a;
        this.y = b;
        this.sum = a + b;
        super();
    }
}

class G {
    private String instance_val;

    {
        instance_val = "instance";
    }

    G(String input) {
        var tmp = input != null ? input : "default";
        var string = tmp + "_initialized";
        super();
        this.instance_val = string;
    }
}
