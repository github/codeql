/**
 * Provides a parameterized module for identifying values that instance-attribute type tracking
 * has re-exposed (laundered) out of an instance attribute, rather than freshly created.
 */

private import python
private import semmle.python.dataflow.new.DataFlow

/** Holds if `node` should be treated as an instance source. */
signature predicate instanceNodeSig(DataFlow::Node node);

/**
 * Provides a predicate for identifying values that instance-attribute type tracking has
 * re-exposed (laundered) out of an instance attribute, rather than freshly created.
 *
 * Instance-attribute type tracking can flow a value into an instance attribute and back out at
 * a later attribute read, for example `BufferedRWPair.reader` or `FileIO.fileno` returning
 * `self._fd`. Such a re-exposed value is owned by the enclosing instance and is not a fresh
 * resource; queries that reason about resource creation or lifetime should not treat it as one.
 *
 * The parameter `isInstance` defines which nodes count as instance sources (typically the result
 * of a class- or resource-instance type tracker).
 */
module ReExposedInstance<instanceNodeSig/1 isInstance> {
  /**
   * Holds if `read` is an attribute read that re-exposes an instance held in an instance
   * attribute.
   */
  private predicate launderedAttrRead(DataFlow::AttrRead read) { isInstance(read) }

  /** Type tracking forward from an attribute read that re-exposes an instance held in a field. */
  private DataFlow::TypeTrackingNode launderedInstance(DataFlow::TypeTracker t) {
    t.start() and
    launderedAttrRead(result)
    or
    exists(DataFlow::TypeTracker t2 | result = launderedInstance(t2).track(t2, t))
  }

  /**
   * Holds if `node` is a value that has been re-exposed (laundered) out of an instance attribute,
   * rather than being a freshly created instance.
   */
  predicate isReExposed(DataFlow::Node node) {
    launderedInstance(DataFlow::TypeTracker::end()).flowsTo(node)
  }
}
