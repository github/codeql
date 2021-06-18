import org.apache.commons.lang3.tuple.Pair;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.MutablePair;

class PairTest {
    String taint() { return "tainted"; }

    private static class IntSource {
      static int taint() { return 0; }
    }

    void sink(Object o) {}

    void test() throws Exception {

      ImmutablePair<String, String> taintedLeft = ImmutablePair.of(taint(), "clean-right");
      ImmutablePair<String, String> taintedRight = ImmutablePair.of("clean-left", taint());
      Pair<String, String> taintedLeft2_ = ImmutablePair.left(taint());
      ImmutablePair<String, String> taintedLeft2 = (ImmutablePair)taintedLeft2_;
      Pair<String, String> taintedRight2_ = ImmutablePair.right(taint());
      ImmutablePair<String, String> taintedRight2 = (ImmutablePair)taintedRight2_;
      Pair<String, String> taintedLeft3 = Pair.of(taint(), "clean-right");
      Pair<String, String> taintedRight3 = Pair.of("clean-left", taint());
      ImmutablePair<String, String> taintedLeft4 = new ImmutablePair(taint(), "clean-right");
      ImmutablePair<String, String> taintedRight4 = new ImmutablePair("clean-left", taint());

      // Check flow through ImmutablePairs:
      sink(taintedLeft.getLeft()); // $hasValueFlow
      sink(taintedLeft.getRight());
      sink(taintedLeft.getKey()); // $hasValueFlow
      sink(taintedLeft.getValue());
      sink(taintedLeft.left); // $hasValueFlow
      sink(taintedLeft.right);
      sink(taintedRight.getLeft());
      sink(taintedRight.getRight()); // $hasValueFlow
      sink(taintedRight.getKey());
      sink(taintedRight.getValue()); // $hasValueFlow
      sink(taintedRight.left);
      sink(taintedRight.right); // $hasValueFlow
      sink(taintedLeft2.getLeft()); // $hasValueFlow
      sink(taintedLeft2.getRight());
      sink(taintedLeft2.getKey()); // $hasValueFlow
      sink(taintedLeft2.getValue());
      sink(taintedLeft2.left); // $hasValueFlow
      sink(taintedLeft2.right);
      sink(taintedRight2.getLeft());
      sink(taintedRight2.getRight()); // $hasValueFlow
      sink(taintedRight2.getKey());
      sink(taintedRight2.getValue()); // $hasValueFlow
      sink(taintedRight2.left);
      sink(taintedRight2.right); // $hasValueFlow
      sink(taintedLeft3.getLeft()); // $hasValueFlow
      sink(taintedLeft3.getRight());
      sink(taintedLeft3.getKey()); // $hasValueFlow
      sink(taintedLeft3.getValue());
      sink(taintedRight3.getLeft());
      sink(taintedRight3.getRight()); // $hasValueFlow
      sink(taintedRight3.getKey());
      sink(taintedRight3.getValue()); // $hasValueFlow
      sink(taintedLeft4.getLeft()); // $hasValueFlow
      sink(taintedLeft4.getRight());
      sink(taintedLeft4.getKey()); // $hasValueFlow
      sink(taintedLeft4.getValue());
      sink(taintedLeft4.left); // $hasValueFlow
      sink(taintedLeft4.right);
      sink(taintedRight4.getLeft());
      sink(taintedRight4.getRight()); // $hasValueFlow
      sink(taintedRight4.getKey());
      sink(taintedRight4.getValue()); // $hasValueFlow
      sink(taintedRight4.left);
      sink(taintedRight4.right); // $hasValueFlow

      // Check flow also works via an alias of type Pair:
      sink(taintedLeft2_.getLeft()); // $hasValueFlow
      sink(taintedLeft2_.getRight());
      sink(taintedLeft2_.getKey()); // $hasValueFlow
      sink(taintedLeft2_.getValue());
      sink(taintedRight2_.getLeft());
      sink(taintedRight2_.getRight()); // $hasValueFlow
      sink(taintedRight2_.getKey());
      sink(taintedRight2_.getValue()); // $hasValueFlow

      // Check flow through MutablePairs:
      MutablePair<String, String> taintedLeftMutable = MutablePair.of(taint(), "clean-right");
      MutablePair<String, String> taintedRightMutable = MutablePair.of("clean-left", taint());
      MutablePair<String, String> setTaintLeft = MutablePair.of("clean-left", "clean-right");
      setTaintLeft.setLeft(taint());
      MutablePair<String, String> setTaintRight = MutablePair.of("clean-left", "clean-right");
      setTaintRight.setRight(taint());
      MutablePair<String, String> setTaintValue = MutablePair.of("clean-left", "clean-right");
      setTaintValue.setValue(taint());
      MutablePair<String, String> taintedLeftMutableConstructed = new MutablePair(taint(), "clean-right");
      MutablePair<String, String> taintedRightMutableConstructed = new MutablePair("clean-left", taint());

      sink(taintedLeftMutable.getLeft()); // $hasValueFlow
      sink(taintedLeftMutable.getRight());
      sink(taintedLeftMutable.getKey()); // $hasValueFlow
      sink(taintedLeftMutable.getValue());
      sink(taintedLeftMutable.left); // $hasValueFlow
      sink(taintedLeftMutable.right);
      sink(taintedRightMutable.getLeft());
      sink(taintedRightMutable.getRight()); // $hasValueFlow
      sink(taintedRightMutable.getKey());
      sink(taintedRightMutable.getValue()); // $hasValueFlow
      sink(taintedRightMutable.left);
      sink(taintedRightMutable.right); // $hasValueFlow
      sink(setTaintLeft.getLeft()); // $hasValueFlow
      sink(setTaintLeft.getRight());
      sink(setTaintLeft.getKey()); // $hasValueFlow
      sink(setTaintLeft.getValue());
      sink(setTaintLeft.left); // $hasValueFlow
      sink(setTaintLeft.right);
      sink(setTaintRight.getLeft());
      sink(setTaintRight.getRight()); // $hasValueFlow
      sink(setTaintRight.getKey());
      sink(setTaintRight.getValue()); // $hasValueFlow
      sink(setTaintRight.left);
      sink(setTaintRight.right); // $hasValueFlow
      sink(setTaintValue.getLeft());
      sink(setTaintValue.getRight()); // $hasValueFlow
      sink(setTaintValue.getKey());
      sink(setTaintValue.getValue()); // $hasValueFlow
      sink(setTaintValue.left);
      sink(setTaintValue.right); // $hasValueFlow
      sink(taintedLeftMutableConstructed.getLeft()); // $hasValueFlow
      sink(taintedLeftMutableConstructed.getRight());
      sink(taintedLeftMutableConstructed.getKey()); // $hasValueFlow
      sink(taintedLeftMutableConstructed.getValue());
      sink(taintedLeftMutableConstructed.left); // $hasValueFlow
      sink(taintedLeftMutableConstructed.right);
      sink(taintedRightMutableConstructed.getLeft());
      sink(taintedRightMutableConstructed.getRight()); // $hasValueFlow
      sink(taintedRightMutableConstructed.getKey());
      sink(taintedRightMutableConstructed.getValue()); // $hasValueFlow
      sink(taintedRightMutableConstructed.left);
      sink(taintedRightMutableConstructed.right); // $hasValueFlow

      // Check flow also works via an alias of type Pair:
      Pair<String, String> taintedLeftMutableAlias = taintedLeftMutable;
      Pair<String, String> taintedRightMutableAlias = taintedRightMutable;
      sink(taintedLeftMutableAlias.getLeft()); // $hasValueFlow
      sink(taintedLeftMutableAlias.getRight());
      sink(taintedLeftMutableAlias.getKey()); // $hasValueFlow
      sink(taintedLeftMutableAlias.getValue());
      sink(taintedRightMutableAlias.getLeft());
      sink(taintedRightMutableAlias.getRight()); // $hasValueFlow
      sink(taintedRightMutableAlias.getKey());
      sink(taintedRightMutableAlias.getValue()); // $hasValueFlow
    }
}