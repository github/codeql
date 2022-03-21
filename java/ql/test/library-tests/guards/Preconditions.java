import org.junit.Assert;
import org.junit.jupiter.api.Assertions;

public class Preconditions {
    public static void guarded() {}

    void test1() {
        Assert.assertTrue(true);
        guarded();
    }

    void test2() {
        Assert.assertTrue(false);
        guarded();
    }

    void test3() {
        Assert.assertFalse(false);
        guarded();
    }

    void test4() {
        Assert.assertFalse(true);
        guarded();
    }

    void test5() {
        Assert.assertTrue("Reason", true);
        guarded();
    }

    void test6() {
        Assert.assertTrue("Reason", false);
        guarded();
    }

    void test7() {
        Assert.assertFalse("Reason", false);
        guarded();
    }

    void test8() {
        Assert.assertFalse("Reason", true);
        guarded();
    }

    void test9() {
        Assertions.assertTrue(true);
        guarded();
    }

    void test10() {
        Assertions.assertTrue(false);
        guarded();
    }

    void test11() {
        Assertions.assertFalse(false);
        guarded();
    }

    void test12() {
        Assertions.assertFalse(true);
        guarded();
    }

    void test13() {
        Assertions.assertTrue(true, "Reason");
        guarded();
    }

    void test14() {
        Assertions.assertTrue(false, "Reason");
        guarded();
    }

    void test15() {
        Assertions.assertFalse(false, "Reason");
        guarded();
    }

    void test16() {
        Assertions.assertFalse(true, "Reason");
        guarded();
    }

    void test17() {
        t(true);
        guarded();
    }

    void test18() {
        t(false);
        guarded();
    }

    void test19() {
        f(false);
        guarded();
    }

    void test20() {
        f(true);
        guarded();
    }

    static void t(boolean b) {
        Assert.assertTrue("Unified Reason", b);
    }

    static void f(boolean b) {
        Assert.assertFalse("Unified Reason", b);
    }
}
