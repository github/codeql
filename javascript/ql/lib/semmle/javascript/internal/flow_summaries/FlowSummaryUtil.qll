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

/**
 * A summary a function that is the default export from an NPM package.
 */
abstract class FunctionalPackageSummary extends SummarizedCallable {
  bindingset[this]
  FunctionalPackageSummary() { any() }

  /** Gets a name of a package for which this summary applies. */
  abstract string getAPackageName();

  override DataFlow::InvokeNode getACallSimple() {
    result = DataFlow::moduleImport(this.getAPackageName()).getAnInvocation()
  }

  override DataFlow::InvokeNode getACall() {
    result = API::moduleImport(this.getAPackageName()).getAnInvocation()
  }
}
