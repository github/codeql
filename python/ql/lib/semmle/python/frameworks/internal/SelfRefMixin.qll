/**
 * INTERNAL: Do not use.
 *
 * Provides the `SelfRefMixin` class.
 */

private import python
private import semmle.python.dataflow.new.DataFlow

/**
 * INTERNAL: Do not use.
 *
 * Adds the `getASelfRef` member predicate when modeling a class.
 */
abstract class SelfRefMixin extends Class {
  /**
   * Gets a reference to instances of this class, originating from a self parameter of
   * a method defined on this class.
   *
   * Note: TODO: This doesn't take MRO into account
   * Note: TODO: This doesn't take staticmethod/classmethod into account
   */
  private DataFlow::TypeTrackingNode getASelfRef(DataFlow::TypeTracker t) {
    t.start() and
    result.(DataFlow::ParameterNode).getParameter() = this.getAMethod().getArg(0)
    or
    exists(DataFlow::TypeTracker t2 | result = this.getASelfRef(t2).track(t2, t))
  }

  /**
   * Gets a reference to instances of this class, originating from a self parameter of
   * a method defined on this class.
   *
   * Note: TODO: This doesn't take MRO into account
   * Note: TODO: This doesn't take staticmethod/classmethod into account
   */
  DataFlow::Node getASelfRef() { this.getASelfRef(DataFlow::TypeTracker::end()).flowsTo(result) }
}
