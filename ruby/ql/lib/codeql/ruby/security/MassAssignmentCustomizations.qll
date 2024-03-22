/**
 * Provides default sources, sinks, sanitizers, and flow steps for
 * detecting insecure mass assignment, as well as extension points for adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.dataflow.RemoteFlowSources

/**
 * Provides default sources, sinks, sanitizers, and flow steps for
 * detecting insecure mass assignment, as well as extension points for adding your own.
 */
module MassAssignment {
  /**
   * A data flow source for user input used for mass assignment.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for user input used for mass assignment.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for insecure mass assignment.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A call that permits arbitrary parameters to be used for mass assignment.
   */
  abstract class MassPermit extends DataFlow::Node {
    /** Gets the argument for the parameters to be permitted */
    abstract DataFlow::Node getParamsArgument();

    /** Gets the result node of the permitted parameters. */
    abstract DataFlow::Node getPermittedParamsResult();
  }

  private class RemoteSource extends Source instanceof RemoteFlowSource { }

  private class PermitBangCall extends MassPermit instanceof DataFlow::CallNode {
    PermitBangCall() { this.asExpr().getExpr().(MethodCall).getMethodName() = "permit!" }

    override DataFlow::Node getParamsArgument() { result = this.(DataFlow::CallNode).getReceiver() }

    override DataFlow::Node getPermittedParamsResult() {
      result = this
      or
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() = this.getParamsArgument()
    }
  }
}
