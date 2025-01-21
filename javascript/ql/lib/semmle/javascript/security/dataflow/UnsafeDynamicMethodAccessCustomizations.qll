/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * method invocations with a user-controlled method name on objects
 * with unsafe methods, as well as extension points for adding your
 * own.
 */

import javascript
import semmle.javascript.frameworks.Express
import PropertyInjectionShared

module UnsafeDynamicMethodAccess {
  private newtype TFlowState =
    TTaint() or
    TUnsafeFunction()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation fo this flow state */
    string toString() {
      this = TTaint() and result = "taint"
      or
      this = TUnsafeFunction() and result = "unsafe-function"
    }

    /** Gets the corresponding flow label. */
    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TTaint() and result.isTaint()
      or
      this = TUnsafeFunction() and result instanceof UnsafeFunction
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** Gets the flow state corresponding to `label`. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

    /** A tainted value. */
    FlowState taint() { result = TTaint() }

    /** A reference to an unsafe function, such as `eval`, obtained by reading from a tainted property name. */
    FlowState unsafeFunction() { result = TUnsafeFunction() }
  }

  /**
   * A data flow source for unsafe dynamic method access.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow state relevant for this source.
     */
    FlowState getAFlowState() { result = FlowState::taint() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for unsafe dynamic method access.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets a flow state relevant for this sink.
     */
    FlowState getAFlowState() { result = FlowState::taint() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A sanitizer for unsafe dynamic method access.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * DEPRECATED. Use `FlowState::unsafeFunction()` instead.
   *
   * Gets the flow label describing values that may refer to an unsafe
   * function as a result of an attacker-controlled property name.
   */
  deprecated UnsafeFunction unsafeFunction() { any() }

  /**
   * DEPRECATED. Use `FlowState::unsafeFunction()` instead.
   *
   * A flow label describing values that may refer to an unsafe
   * function as a result of an attacker-controlled property name.
   */
  abstract deprecated class UnsafeFunction extends DataFlow::FlowLabel {
    UnsafeFunction() { this = "UnsafeFunction" }
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
   * A function invocation of an unsafe function, as a sink for remote unsafe dynamic method access.
   */
  class CalleeAsSink extends Sink {
    CalleeAsSink() { this = any(DataFlow::InvokeNode node).getCalleeNode() }

    override FlowState getAFlowState() { result = FlowState::unsafeFunction() }
  }
}
