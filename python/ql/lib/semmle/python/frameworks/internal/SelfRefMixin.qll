/**
 * INTERNAL: Do not use.
 *
 * Provides the `SelfRefMixin` class.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowDispatch

/**
 * INTERNAL: Do not use.
 *
 * Adds the `getASelfRef` member predicate when modeling a class.
 */
abstract class SelfRefMixin extends Class {
  /**
   * Gets a reference to instances of this class, originating from a self parameter of
   * a method defined on this class.
   */
  private DataFlow::TypeTrackingNode getASelfRef(DataFlow::TypeTracker t) {
    t.start() and
    exists(Class cls, Function meth |
      cls = getADirectSuperclass*(this) and
      meth = cls.getAMethod() and
      not isStaticmethod(meth) and
      not isClassmethod(meth) and
      result.(DataFlow::ParameterNode).getParameter() = meth.getArg(0)
    )
    or
    exists(DataFlow::TypeTracker t2 | result = this.getASelfRef(t2).track(t2, t))
  }

  /**
   * Gets a reference to instances of this class, originating from a self parameter of
   * a method defined on this class.
   */
  DataFlow::Node getASelfRef() { this.getASelfRef(DataFlow::TypeTracker::end()).flowsTo(result) }
}
