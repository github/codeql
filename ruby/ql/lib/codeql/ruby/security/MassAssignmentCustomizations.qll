/**
 * Provides default sources, sinks, sanitizers, and flow steps for
 * detecting insecure mass assignment, as well as extension points for adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.controlflow.CfgNodes
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
    /** Gets the argument for the parameters to be permitted. */
    abstract DataFlow::Node getParamsArgument();

    /** Gets the result node of the permitted parameters. */
    abstract DataFlow::Node getPermittedParamsResult();
  }

  private class RemoteSource extends Source instanceof RemoteFlowSource { }

  /** A call to `permit!`, which permits each key of its receiver. */
  private class PermitBangCall extends MassPermit instanceof DataFlow::CallNode {
    PermitBangCall() { this.(DataFlow::CallNode).getMethodName() = "permit!" }

    override DataFlow::Node getParamsArgument() { result = this.(DataFlow::CallNode).getReceiver() }

    override DataFlow::Node getPermittedParamsResult() {
      result = this
      or
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() = this.getParamsArgument()
    }
  }

  /** Holds if `h` is an empty hash or contains an empty hash at one if its (possibly nested) values. */
  private predicate hasEmptyHash(ExprCfgNode e) {
    e instanceof ExprNodes::HashLiteralCfgNode and
    not exists(e.(ExprNodes::HashLiteralCfgNode).getAKeyValuePair())
    or
    hasEmptyHash(e.(ExprNodes::HashLiteralCfgNode).getAKeyValuePair().getValue())
    or
    hasEmptyHash(e.(ExprNodes::PairCfgNode).getValue())
    or
    hasEmptyHash(e.(ExprNodes::ArrayLiteralCfgNode).getAnArgument())
  }

  /** A call to `permit` that fully specifies the permitted parameters. */
  private class PermitCallSanitizer extends Sanitizer, DataFlow::CallNode {
    PermitCallSanitizer() {
      this.getMethodName() = "permit" and
      not hasEmptyHash(this.getArgument(_).getExprNode())
    }
  }

  /** A call to `permit` that uses an empty hash, which allows arbitrary keys to be specified. */
  private class PermitCallMassPermit extends MassPermit instanceof DataFlow::CallNode {
    PermitCallMassPermit() {
      this.(DataFlow::CallNode).getMethodName() = "permit" and
      hasEmptyHash(this.(DataFlow::CallNode).getArgument(_).getExprNode())
    }

    override DataFlow::Node getParamsArgument() { result = this.(DataFlow::CallNode).getReceiver() }

    override DataFlow::Node getPermittedParamsResult() { result = this }
  }

  /** A call to `to_unsafe_h`, which allows arbitrary parameter. */
  private class ToUnsafeHashCall extends MassPermit instanceof DataFlow::CallNode {
    ToUnsafeHashCall() { this.(DataFlow::CallNode).getMethodName() = "to_unsafe_h" }

    override DataFlow::Node getParamsArgument() { result = this.(DataFlow::CallNode).getReceiver() }

    override DataFlow::Node getPermittedParamsResult() { result = this }
  }
}
