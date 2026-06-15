/**
 * Provides sources, sinks, and sanitizers for reasoning about assignments
 * that my cause prototype pollution.
 */

private import javascript

/**
 * Provides sources, sinks, and sanitizers for reasoning about assignments
 * that my cause prototype pollution.
 */
module PrototypePollutingAssignment {
  private newtype TFlowState =
    TTaint() or
    TObjectPrototype()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation fo this flow state */
    string toString() {
      this = TTaint() and result = "taint"
      or
      this = TObjectPrototype() and result = "object-prototype"
    }

    /** Gets the corresponding flow label. */
    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TTaint() and result.isTaint()
      or
      this = TObjectPrototype() and result instanceof ObjectPrototype
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** Gets the flow state corresponding to `label`. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

    /** A tainted value. */
    FlowState taint() { result = TTaint() }

    /** A reference to `Object.prototype` obtained by reading from a tainted property name. */
    FlowState objectPrototype() { result = TObjectPrototype() }
  }

  /**
   * A data flow source for untrusted data from which the special `__proto__` property name may be arise.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a string that describes the type of source.
     */
    abstract string describe();
  }

  /**
   * A data flow sink for prototype-polluting assignments or untrusted property names.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this sink.
     *
     * Use the `taint` label for untrusted property names, and the `ObjectPrototype` label for
     * object mutations.
     */
    FlowState getAFlowState() { result = FlowState::objectPrototype() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A sanitizer for untrusted property names.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A barrier guard for prototype-polluting assignments.
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

  /** A flow label representing the `Object.prototype` value. */
  abstract deprecated class ObjectPrototype extends DataFlow::FlowLabel {
    ObjectPrototype() { this = "Object.prototype" }
  }

  /** The base of an assignment or extend call, as a sink for `Object.prototype` references. */
  private class DefaultSink extends Sink {
    DefaultSink() {
      // Avoid using PropWrite here as we only want assignments that can mutate a pre-existing object,
      // so not object literals or array literals.
      this = any(AssignExpr assign).getTarget().(PropAccess).getBase().flow()
      or
      this = any(ExtendCall c).getDestinationOperand()
      or
      this = any(DeleteExpr del).getOperand().flow().(DataFlow::PropRef).getBase()
    }

    override FlowState getAFlowState() { result = FlowState::objectPrototype() }
  }

  /** A remote flow source or location.{hash,search} as a taint source. */
  private class DefaultSource extends Source instanceof RemoteFlowSource {
    override string describe() { result = "user controlled input" }
  }

  import semmle.javascript.PackageExports as Exports

  /**
   * A parameter of an exported function, seen as a source prototype-polluting assignment.
   */
  class ExternalInputSource extends Source {
    ExternalInputSource() {
      this = Exports::getALibraryInputParameter() and not this instanceof RemoteFlowSource
    }

    override string describe() { result = "library input" }
  }
}
