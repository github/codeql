private import javascript
private import semmle.javascript.dataflow.FlowSummary
private import semmle.javascript.dataflow.internal.Contents::Private

/**
 * A method call or a reflective invocation (`call` or `apply`) that takes a receiver.
 *
 * Note that `DataFlow::MethodCallNode` does not include reflective invocation.
 */
class InstanceCall extends DataFlow::CallNode {
  InstanceCall() { exists(this.getReceiver()) }

  /** Gets the name of method being invoked */
  string getMethodName() { result = this.getCalleeName() }
}
