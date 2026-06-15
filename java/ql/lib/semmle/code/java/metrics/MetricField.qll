/**
 * Provides classes and predicates for computing metrics on Java fields.
 */
overlay[local?]
module;

import semmle.code.java.Member

/** This class provides access to metrics information for fields. */
class MetricField extends Field {
  /**
   * The afferent coupling of a field is defined as
   * the number of callables that access it.
   */
  int getAfferentCoupling() { result = count(Callable m | m.accesses(this)) }
}
