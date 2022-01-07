import org.apache.commons.lang3.ArrayUtils;
import java.io.StringReader;
import java.nio.CharBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

class ArrayUtilsTest {
    String taint() { return "tainted"; }

    private static class IntSource {
      static int taint() { return 0; }
    }

    void sink(Object o) {}

    void test() throws Exception {

      // All methods of this class copy the input array, so the incoming array should not be assigned taint.
      String[] alreadyTainted = new String[] { taint() };
      String[] clean = new String[] { "Untainted" };

      sink(ArrayUtils.add(clean, 0, taint())); // $hasTaintFlow
      sink(ArrayUtils.add(alreadyTainted, 0, "clean")); // $hasTaintFlow
      sink(ArrayUtils.add(clean, IntSource.taint(), "clean")); // Index argument does not contribute taint
      sink(ArrayUtils.add(clean, taint())); // $hasTaintFlow
      sink(ArrayUtils.add(alreadyTainted, "clean")); // $hasTaintFlow
      sink(ArrayUtils.addAll(clean, "clean", taint())); // $hasTaintFlow
      sink(ArrayUtils.addAll(clean, taint(), "clean")); // $hasTaintFlow
      sink(ArrayUtils.addAll(alreadyTainted, "clean", "also clean")); // $hasTaintFlow
      sink(ArrayUtils.addFirst(clean, taint())); // $hasTaintFlow
      sink(ArrayUtils.addFirst(alreadyTainted, "clean")); // $hasTaintFlow
      sink(ArrayUtils.clone(alreadyTainted)); // $hasTaintFlow
      sink(ArrayUtils.get(alreadyTainted, 0)); // $hasValueFlow
      sink(ArrayUtils.get(clean, IntSource.taint())); // Index argument does not contribute taint
      sink(ArrayUtils.get(alreadyTainted, 0, "default value")); // $hasValueFlow
      sink(ArrayUtils.get(clean, IntSource.taint(), "default value")); // Index argument does not contribute taint
      sink(ArrayUtils.get(clean, 0, taint())); // $hasValueFlow
      sink(ArrayUtils.insert(IntSource.taint(), clean, "value1", "value2")); // Index argument does not contribute taint
      sink(ArrayUtils.insert(0, alreadyTainted, "value1", "value2")); // $hasTaintFlow
      sink(ArrayUtils.insert(0, clean, taint(), "value2")); // $hasTaintFlow
      sink(ArrayUtils.insert(0, clean, "value1", taint())); // $hasTaintFlow
      sink(ArrayUtils.nullToEmpty(alreadyTainted)); // $hasTaintFlow
      sink(ArrayUtils.nullToEmpty(alreadyTainted, String[].class)); // $hasTaintFlow
      sink(ArrayUtils.remove(alreadyTainted, 0)); // $hasTaintFlow
      sink(ArrayUtils.remove(clean, IntSource.taint())); // Index argument does not contribute taint
      sink(ArrayUtils.removeAll(alreadyTainted, 0, 1)); // $hasTaintFlow
      sink(ArrayUtils.removeAll(clean, IntSource.taint(), 1)); // Index argument does not contribute taint
      sink(ArrayUtils.removeAll(clean, 0, IntSource.taint())); // Index argument does not contribute taint
      sink(ArrayUtils.removeAllOccurences(clean, taint())); // Removed argument does not contribute taint
      sink(ArrayUtils.removeAllOccurences(alreadyTainted, "value to remove")); // $hasTaintFlow
      sink(ArrayUtils.removeAllOccurrences(clean, taint())); // Removed argument does not contribute taint
      sink(ArrayUtils.removeAllOccurrences(alreadyTainted, "value to remove")); // $hasTaintFlow
      sink(ArrayUtils.removeElement(clean, taint())); // Removed argument does not contribute taint
      sink(ArrayUtils.removeElement(alreadyTainted, "value to remove")); // $hasTaintFlow
      sink(ArrayUtils.removeElements(alreadyTainted, 0, 1)); // $hasTaintFlow
      sink(ArrayUtils.removeElements(clean, IntSource.taint(), 1)); // Index argument does not contribute taint
      sink(ArrayUtils.removeElements(clean, 0, IntSource.taint())); // Index argument does not contribute taint
      sink(ArrayUtils.subarray(alreadyTainted, 0, 0)); // $hasTaintFlow
      sink(ArrayUtils.subarray(clean, IntSource.taint(), IntSource.taint())); // Index arguments do not contribute taint
      sink(ArrayUtils.toArray("clean", taint())); // $hasTaintFlow
      sink(ArrayUtils.toArray(taint(), "clean")); // $hasTaintFlow
      sink(ArrayUtils.toMap(alreadyTainted).get("key")); // $hasTaintFlow

      // Check that none of the above had an effect on `clean`:
      sink(clean);

      int[] taintedInts = new int[] { IntSource.taint() };
      Integer[] taintedBoxedInts = ArrayUtils.toObject(taintedInts);
      sink(taintedBoxedInts); // $hasTaintFlow
      sink(ArrayUtils.toPrimitive(taintedBoxedInts)); // $hasTaintFlow
      sink(ArrayUtils.toPrimitive(new Integer[] {}, IntSource.taint())); // $hasTaintFlow

    }
  }
