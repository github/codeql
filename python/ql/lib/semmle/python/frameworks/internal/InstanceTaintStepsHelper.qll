/**
 * INTERNAL: Do no use.
 *
 * Provides helper class for defining additional taint step.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking

/**
 * A helper class for defining additional taint steps.
 */
bindingset[this]
abstract class InstanceTaintStepsHelper extends string {
  /** Gets an instance that the additional taint steps should be applied to. */
  abstract DataFlow::Node getInstance();

  /** Gets the name of an attribute that should be tainted. */
  abstract string getAttributeName();

  /** Gets the name of a method, whose results should be tainted. */
  abstract string getMethodName();

  /** Gets the name of an async method, whose results should be tainted. */
  abstract string getAsyncMethodName();
}

private class InstanceAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(InstanceTaintStepsHelper helper |
      // normal (non-async) methods
      nodeFrom = helper.getInstance() and
      nodeTo.(DataFlow::MethodCallNode).calls(nodeFrom, helper.getMethodName())
      or
      // async methods.
      //
      // since we have general taint-step from `foo` in `await foo` to the whole
      // expression, we simply taint the awaitable that is the result of "calling" the
      // async method. That also allows such an awaitable to be placed in a list (for
      // use with `asyncio.gather` for example), and thereby propagate taint to the
      // list.
      nodeFrom = helper.getInstance() and
      nodeTo.(DataFlow::MethodCallNode).calls(nodeFrom, helper.getAsyncMethodName())
      or
      // Attributes
      nodeFrom = helper.getInstance() and
      nodeTo.(DataFlow::AttrRead).accesses(nodeFrom, helper.getAttributeName())
    )
  }
}
