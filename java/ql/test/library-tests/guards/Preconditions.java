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
        r(true);
        guarded();
    }

    static void r(boolean b) {
        Assert.assertTrue("Unified Reason", b);
    }

    void test10() {
        Assertions.assertTrue(true);
        guarded();
    }

    void test11() {
        Assertions.assertTrue(false);
        guarded();
    }

    void test12() {
        Assertions.assertFalse(false);
        guarded();
    }

    void test13() {
        Assertions.assertFalse(true);
        guarded();
    }

    void test14() {
        Assertions.assertTrue(true, "Reason");
        guarded();
    }

    void test15() {
        Assertions.assertTrue(false, "Reason");
        guarded();
    }

    void test16() {
        Assertions.assertFalse(false, "Reason");
        guarded();
    }

    void test17() {
        Assertions.assertFalse(true, "Reason");
        guarded();
    }
}
