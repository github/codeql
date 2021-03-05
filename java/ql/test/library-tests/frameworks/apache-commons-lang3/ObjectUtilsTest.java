import org.apache.commons.lang3.ObjectUtils;

public class ObjectUtilsTest {
  String taint() { return "tainted"; }

  void sink(Object o) {}

  void test() throws Exception {
    sink(ObjectUtils.clone(taint())); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.cloneIfPossible(taint())); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.CONST(taint())); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.defaultIfNull(taint(), null)); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.defaultIfNull(null, taint())); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.firstNonNull(taint(), null, null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.firstNonNull(null, taint(), null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.firstNonNull(null, null, taint())); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.getIfNull(taint(), null)); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.max(taint(), null, null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.max(null, taint(), null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.max(null, null, taint())); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.median(taint(), null, null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.median((String)null, taint(), null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.median((String)null, null, taint())); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.min(taint(), null, null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.min(null, taint(), null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.min(null, null, taint())); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.mode(taint(), null, null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.mode(null, taint(), null)); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.mode(null, null, taint())); // $hasTaintFlow=y $MISSING:hasValueFlow=y
    sink(ObjectUtils.requireNonEmpty(taint(), "message")); // $hasTaintFlow=y $hasValueFlow=y
    sink(ObjectUtils.requireNonEmpty("not null", taint())); // GOOD (message doesn't propagate to the return)
    sink(ObjectUtils.toString(taint(), "default string")); // GOOD (first argument is stringified)
    sink(ObjectUtils.toString(null, taint())); // $hasTaintFlow=y $hasValueFlow=y
  }
}
