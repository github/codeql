/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unvalidated dynamic method calls, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared
private import semmle.javascript.dataflow.InferredTypes

module UnvalidatedDynamicMethodCall {
  private import DataFlow::FlowLabel

  /**
   * A data flow source for unvalidated dynamic method calls.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this source.
     */
    DataFlow::FlowLabel getFlowLabel() { result = taint() }
  }

  /**
   * A data flow sink for unvalidated dynamic method calls.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this sink
     */
    abstract DataFlow::FlowLabel getFlowLabel();
  }

  /**
   * A sanitizer for unvalidated dynamic method calls.
   * Override the `sanitizes` predicate to specify an edge that should be sanitized.
   * The `this` value is not seen as a sanitizer.
   */
  abstract class Sanitizer extends DataFlow::Node {
    abstract predicate sanitizes(DataFlow::Node source, DataFlow::Node sink, DataFlow::FlowLabel lbl);
  }

  /**
   * A flow label describing values read from a user-controlled property that
   * may not be functions.
   */
  abstract class MaybeNonFunction extends DataFlow::FlowLabel {
    MaybeNonFunction() { this = "MaybeNonFunction" }
  }

  /**
   * A flow label describing values read from a user-controlled property that
   * may originate from a prototype object.
   */
  abstract class MaybeFromProto extends DataFlow::FlowLabel {
    MaybeFromProto() { this = "MaybeFromProto" }
  }

  /**
   * A source of remote user input, considered as a source for unvalidated dynamic method calls.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * The page URL considered as a flow source for unvalidated dynamic method calls.
   */
  class DocumentUrlAsSource extends Source {
    DocumentUrlAsSource() { this = DOM::locationSource() }
  }

  /**
   * A function invocation of an unsafe function, as a sink for remote unvalidated dynamic method calls.
   */
  class CalleeAsSink extends Sink {
    CalleeAsSink() {
      exists(InvokeExpr invk |
        this = invk.getCallee().flow() and
        // don't flag invocations inside a try-catch
        not invk.getASuccessor() instanceof CatchClause
      )
    }

    override DataFlow::FlowLabel getFlowLabel() {
      result instanceof MaybeNonFunction and
      // don't flag if the type inference can prove that it is a function;
      // this complements the `FunctionCheck` sanitizer below: the type inference can
      // detect more checks locally, but doesn't provide inter-procedural reasoning
      this.analyze().getAType() != TTFunction()
      or
      result instanceof MaybeFromProto
    }
  }

  /**
   * A check of the form `typeof x === 'function'`, which sanitizes away the `MaybeNonFunction`
   * taint kind.
   */
  class FunctionCheck extends TaintTracking::LabeledSanitizerGuardNode, DataFlow::ValueNode {
    override EqualityTest astNode;
    Expr operand;

    FunctionCheck() { TaintTracking::isTypeofGuard(astNode, operand, "function") }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      outcome = astNode.getPolarity() and
      e = operand and
      label instanceof MaybeNonFunction
    }
  }

  /** A guard that checks whether `x` is a number. */
  class NumberGuard extends TaintTracking::SanitizerGuardNode instanceof DataFlow::CallNode {
    Expr x;
    boolean polarity;

    NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

    override predicate sanitizes(boolean outcome, Expr e) { e = x and outcome = polarity }
  }
}
