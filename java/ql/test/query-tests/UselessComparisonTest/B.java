import java.util.*;
import java.util.function.*;

public class B {
  int modcount = 0;

  int[] arr;

  public void modify(IntUnaryOperator func) {
    int mc = modcount;
    for (int i = 0; i < arr.length; i++) {
      arr[i] = func.applyAsInt(arr[i]);
    }
    // Always false unless there is a call path from func.applyAsInt(..) to
    // this method, but should not be reported, as checks guarding
    // ConcurrentModificationExceptions are expected to always be false in the
    // absence of API misuse.
    if (mc != modcount)
      throw new ConcurrentModificationException();
    modcount++;
  }
}
