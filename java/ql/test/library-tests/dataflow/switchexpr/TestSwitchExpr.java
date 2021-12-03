class TestSwitchExpr {
    Object source() { return new Object(); }

    void sink(Object o) { }

    void test(String s) {
        Object x1 = source();
        Object x2 = switch (s) {
            case "a", "b", ("a" + "b") -> null;
            default -> x1;
        };
        Object x3 = switch (s) {
            case "c", "d" -> { yield x2; }
            default -> throw new RuntimeException();
        };
        Object x4 = switch (s) {
            case "a", "b":
            case "c", "d", ("c" + "d"):
                yield x3;
            default:
                throw new RuntimeException();
        };
        sink(x4);
    }
}
