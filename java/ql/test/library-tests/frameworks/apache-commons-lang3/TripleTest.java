import org.apache.commons.lang3.tuple.Triple;
import org.apache.commons.lang3.tuple.ImmutableTriple;
import org.apache.commons.lang3.tuple.MutableTriple;

class TripleTest {
    String taint() { return "tainted"; }

    private static class IntSource {
      static int taint() { return 0; }
    }

    void sink(Object o) {}

    void test() throws Exception {

      ImmutableTriple<String, String, String> taintedLeft = ImmutableTriple.of(taint(), "clean-middle", "clean-right");
      ImmutableTriple<String, String, String> taintedMiddle = ImmutableTriple.of("clean-left", taint(), "clean-right");
      ImmutableTriple<String, String, String> taintedRight = ImmutableTriple.of("clean-left", "clean-middle", taint());

      // Check flow through ImmutableTriples:
      sink(taintedLeft.getLeft()); // $hasValueFlow
      sink(taintedLeft.getMiddle());
      sink(taintedLeft.getRight());
      sink(taintedLeft.left); // $hasValueFlow
      sink(taintedLeft.middle);
      sink(taintedLeft.right);
      sink(taintedMiddle.getLeft());
      sink(taintedMiddle.getMiddle()); // $hasValueFlow
      sink(taintedMiddle.getRight());
      sink(taintedMiddle.left);
      sink(taintedMiddle.middle); // $hasValueFlow
      sink(taintedMiddle.right);
      sink(taintedRight.getLeft());
      sink(taintedRight.getMiddle());
      sink(taintedRight.getRight()); // $hasValueFlow
      sink(taintedRight.left);
      sink(taintedRight.middle);
      sink(taintedRight.right); // $hasValueFlow

      Triple<String, String, String> taintedLeft2 = taintedLeft;
      Triple<String, String, String> taintedMiddle2 = taintedMiddle;
      Triple<String, String, String> taintedRight2 = taintedRight;

      // Check flow also works via an alias of type Triple:
      sink(taintedLeft2.getLeft()); // $hasValueFlow
      sink(taintedLeft2.getMiddle());
      sink(taintedLeft2.getRight());
      sink(taintedMiddle2.getLeft());
      sink(taintedMiddle2.getMiddle()); // $hasValueFlow
      sink(taintedMiddle2.getRight());
      sink(taintedRight2.getLeft());
      sink(taintedRight2.getMiddle());
      sink(taintedRight2.getRight()); // $hasValueFlow

      // Check flow via Triple.of:
      Triple<String, String, String> taintedLeft3 = Triple.of(taint(), "clean-middle", "clean-right");
      Triple<String, String, String> taintedMiddle3 = Triple.of("clean-left", taint(), "clean-right");
      Triple<String, String, String> taintedRight3 = Triple.of("clean-left", "clean-middle", taint());

      sink(taintedLeft3.getLeft()); // $hasValueFlow
      sink(taintedLeft3.getMiddle());
      sink(taintedLeft3.getRight());
      sink(taintedMiddle3.getLeft());
      sink(taintedMiddle3.getMiddle()); // $hasValueFlow
      sink(taintedMiddle3.getRight());
      sink(taintedRight3.getLeft());
      sink(taintedRight3.getMiddle());
      sink(taintedRight3.getRight()); // $hasValueFlow

      // Check flow via constructor:
      ImmutableTriple<String, String, String> taintedLeft4 = new ImmutableTriple(taint(), "clean-middle", "clean-right");
      ImmutableTriple<String, String, String> taintedMiddle4 = new ImmutableTriple("clean-left", taint(), "clean-right");
      ImmutableTriple<String, String, String> taintedRight4 = new ImmutableTriple("clean-left", "clean-middle", taint());

      sink(taintedLeft4.getLeft()); // $hasValueFlow
      sink(taintedLeft4.getMiddle());
      sink(taintedLeft4.getRight());
      sink(taintedMiddle4.getLeft());
      sink(taintedMiddle4.getMiddle()); // $hasValueFlow
      sink(taintedMiddle4.getRight());
      sink(taintedRight4.getLeft());
      sink(taintedRight4.getMiddle());
      sink(taintedRight4.getRight()); // $hasValueFlow

      MutableTriple<String, String, String> mutableTaintedLeft = MutableTriple.of(taint(), "clean-middle", "clean-right");
      MutableTriple<String, String, String> mutableTaintedMiddle = MutableTriple.of("clean-left", taint(), "clean-right");
      MutableTriple<String, String, String> mutableTaintedRight = MutableTriple.of("clean-left", "clean-middle", taint());
      MutableTriple<String, String, String> setTaintedLeft = MutableTriple.of("clean-left", "clean-middle", "clean-right");
      setTaintedLeft.setLeft(taint());
      MutableTriple<String, String, String> setTaintedMiddle = MutableTriple.of("clean-left", "clean-middle", "clean-right");
      setTaintedMiddle.setMiddle(taint());
      MutableTriple<String, String, String> setTaintedRight = MutableTriple.of("clean-left", "clean-middle", "clean-right");
      setTaintedRight.setRight(taint());
      MutableTriple<String, String, String> mutableTaintedLeftConstructed = new MutableTriple(taint(), "clean-middle", "clean-right");
      MutableTriple<String, String, String> mutableTaintedMiddleConstructed = new MutableTriple("clean-left", taint(), "clean-right");
      MutableTriple<String, String, String> mutableTaintedRightConstructed = new MutableTriple("clean-left", "clean-middle", taint());

      // Check flow through MutableTriples:
      sink(mutableTaintedLeft.getLeft()); // $hasValueFlow
      sink(mutableTaintedLeft.getMiddle());
      sink(mutableTaintedLeft.getRight());
      sink(mutableTaintedLeft.left); // $hasValueFlow
      sink(mutableTaintedLeft.middle);
      sink(mutableTaintedLeft.right);
      sink(mutableTaintedMiddle.getLeft());
      sink(mutableTaintedMiddle.getMiddle()); // $hasValueFlow
      sink(mutableTaintedMiddle.getRight());
      sink(mutableTaintedMiddle.left);
      sink(mutableTaintedMiddle.middle); // $hasValueFlow
      sink(mutableTaintedMiddle.right);
      sink(mutableTaintedRight.getLeft());
      sink(mutableTaintedRight.getMiddle());
      sink(mutableTaintedRight.getRight()); // $hasValueFlow
      sink(mutableTaintedRight.left);
      sink(mutableTaintedRight.middle);
      sink(mutableTaintedRight.right); // $hasValueFlow
      sink(setTaintedLeft.getLeft()); // $hasValueFlow
      sink(setTaintedLeft.getMiddle());
      sink(setTaintedLeft.getRight());
      sink(setTaintedLeft.left); // $hasValueFlow
      sink(setTaintedLeft.middle);
      sink(setTaintedLeft.right);
      sink(setTaintedMiddle.getLeft());
      sink(setTaintedMiddle.getMiddle()); // $hasValueFlow
      sink(setTaintedMiddle.getRight());
      sink(setTaintedMiddle.left);
      sink(setTaintedMiddle.middle); // $hasValueFlow
      sink(setTaintedMiddle.right);
      sink(setTaintedRight.getLeft());
      sink(setTaintedRight.getMiddle());
      sink(setTaintedRight.getRight()); // $hasValueFlow
      sink(setTaintedRight.left);
      sink(setTaintedRight.middle);
      sink(setTaintedRight.right); // $hasValueFlow
      sink(mutableTaintedLeftConstructed.getLeft()); // $hasValueFlow
      sink(mutableTaintedLeftConstructed.getMiddle());
      sink(mutableTaintedLeftConstructed.getRight());
      sink(mutableTaintedLeftConstructed.left); // $hasValueFlow
      sink(mutableTaintedLeftConstructed.middle);
      sink(mutableTaintedLeftConstructed.right);
      sink(mutableTaintedMiddleConstructed.getLeft());
      sink(mutableTaintedMiddleConstructed.getMiddle()); // $hasValueFlow
      sink(mutableTaintedMiddleConstructed.getRight());
      sink(mutableTaintedMiddleConstructed.left);
      sink(mutableTaintedMiddleConstructed.middle); // $hasValueFlow
      sink(mutableTaintedMiddleConstructed.right);
      sink(mutableTaintedRightConstructed.getLeft());
      sink(mutableTaintedRightConstructed.getMiddle());
      sink(mutableTaintedRightConstructed.getRight()); // $hasValueFlow
      sink(mutableTaintedRightConstructed.left);
      sink(mutableTaintedRightConstructed.middle);
      sink(mutableTaintedRightConstructed.right); // $hasValueFlow

      Triple<String, String, String> mutableTaintedLeft2 = mutableTaintedLeft;
      Triple<String, String, String> mutableTaintedMiddle2 = mutableTaintedMiddle;
      Triple<String, String, String> mutableTaintedRight2 = mutableTaintedRight;
      Triple<String, String, String> setTaintedLeft2 = setTaintedLeft;
      Triple<String, String, String> setTaintedMiddle2 = setTaintedMiddle;
      Triple<String, String, String> setTaintedRight2 = setTaintedRight;

      // Check flow also works via an alias of type Triple:
      sink(mutableTaintedLeft2.getLeft()); // $hasValueFlow
      sink(mutableTaintedLeft2.getMiddle());
      sink(mutableTaintedLeft2.getRight());
      sink(mutableTaintedMiddle2.getLeft());
      sink(mutableTaintedMiddle2.getMiddle()); // $hasValueFlow
      sink(mutableTaintedMiddle2.getRight());
      sink(mutableTaintedRight2.getLeft());
      sink(mutableTaintedRight2.getMiddle());
      sink(mutableTaintedRight2.getRight()); // $hasValueFlow
      sink(setTaintedLeft2.getLeft()); // $hasValueFlow
      sink(setTaintedLeft2.getMiddle());
      sink(setTaintedLeft2.getRight());
      sink(setTaintedMiddle2.getLeft());
      sink(setTaintedMiddle2.getMiddle()); // $hasValueFlow
      sink(setTaintedMiddle2.getRight());
      sink(setTaintedRight2.getLeft());
      sink(setTaintedRight2.getMiddle());
      sink(setTaintedRight2.getRight()); // $hasValueFlow
    }
}