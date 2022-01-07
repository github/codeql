class Test {
    // Nested records are implicitly static
    record R1() { }
    static final record R2() { }

    interface SuperInterface { }

    record R3() implements SuperInterface { }

    void test() {
        // Nested records are implicitly static
        record LocalRecord() { }
    }
}
