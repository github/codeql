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
  private newtype TFlowState =
    TTaint() or
    TMaybeNonFunction() or
    TMaybeFromProto()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation fo this flow state */
    string toString() {
      this = TTaint() and result = "taint"
      or
      this = TMaybeNonFunction() and result = "maybe-non-function"
      or
      this = TMaybeFromProto() and result = "maybe-from-proto"
    }

    /** Gets the corresponding flow label. */
    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TTaint() and result.isTaint()
      or
      this = TMaybeNonFunction() and result instanceof MaybeNonFunction
      or
      this = TMaybeFromProto() and result instanceof MaybeFromProto
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** Gets the flow state corresponding to `label`. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

    /** A tainted value. */
    FlowState taint() { result = TTaint() }

    /**
     * A non-function value, obtained by reading from a tainted property name.
     */
    FlowState maybeNonFunction() { result = TMaybeNonFunction() }

    /**
     * A value obtained from a prototype object while reading from a tainted property name.
     */
    FlowState maybeFromProto() { result = TMaybeFromProto() }
  }

  /**
   * A data flow source for unvalidated dynamic method calls.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the flow state relevant for this source.
     */
    FlowState getAFlowState() { result = FlowState::taint() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for unvalidated dynamic method calls.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the flow state relevant for this sink
     */
    FlowState getAFlowState() { result = FlowState::taint() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A sanitizer for unvalidated dynamic method calls.
   */
  abstract class Sanitizer extends DataFlow::Node {
    /**
     * Gets a flow state blocked by this sanitizer.
     */
    FlowState getAFlowState() { result = FlowState::taint() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getFlowLabel() { result = this.getAFlowState().toFlowLabel() }

    /**
     * DEPRECATED. Use sanitizer nodes instead.
     *
     * This predicate no longer has any effect. The `this` value of `Sanitizer` is instead
     * treated as a sanitizing node, that is, flow in and out of that node is prohibited.
     */
    deprecated predicate sanitizes(
      DataFlow::Node source, DataFlow::Node sink, DataFlow::FlowLabel lbl
    ) {
      none()
    }
  }

  /**
   * A barrier guard for unvalidated dynamic method calls.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /**
     * Holds if this node acts as a barrier for `state`, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e, FlowState state) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      this.blocksExpr(outcome, e, FlowState::fromFlowLabel(label))
    }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      BarrierGuard.super.sanitizes(outcome, e, label)
    }
  }

  /**
   * A flow label describing values read from a user-controlled property that
   * may not be functions.
   */
  abstract deprecated class MaybeNonFunction extends DataFlow::FlowLabel {
    MaybeNonFunction() { this = "MaybeNonFunction" }
  }

  /**
   * A flow label describing values read from a user-controlled property that
   * may originate from a prototype object.
   */
  abstract deprecated class MaybeFromProto extends DataFlow::FlowLabel {
    MaybeFromProto() { this = "MaybeFromProto" }
  }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

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
        not invk.getASuccessor() instanceof CatchClause and
        // Filter out `foo.bar()` calls as they usually aren't interesting.
        // Technically this could be reachable if preceded by `foo.bar = obj[taint]`
        // but such sinks are more likely to be FPs and also slow down the query.
        not invk.getCallee() instanceof DotExpr
      )
    }

    override FlowState getAFlowState() {
      result = FlowState::maybeNonFunction() and
      // don't flag if the type inference can prove that it is a function;
      // this complements the `FunctionCheck` sanitizer below: the type inference can
      // detect more checks locally, but doesn't provide inter-procedural reasoning
      this.analyze().getAType() != TTFunction()
      or
      result = FlowState::maybeFromProto()
    }
  }

  /**
   * A check of the form `typeof x === 'function'`, which sanitizes away the `MaybeNonFunction`
   * taint kind.
   */
  class FunctionCheck extends BarrierGuard, DataFlow::ValueNode {
    override EqualityTest astNode;
    Expr operand;

    FunctionCheck() { TaintTracking::isTypeofGuard(astNode, operand, "function") }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      outcome = astNode.getPolarity() and
      e = operand and
      state = FlowState::maybeNonFunction()
    }
  }

  /** A guard that checks whether `x` is a number. */
  class NumberGuard extends BarrierGuard instanceof DataFlow::CallNode {
    Expr x;
    boolean polarity;

    NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

    override predicate blocksExpr(boolean outcome, Expr e) { e = x and outcome = polarity }
  }
}
