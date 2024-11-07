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
  private import DataFlow::FlowLabel

  /**
   * A data flow source for unsafe dynamic method access.
   */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this source.
     */
    DataFlow::FlowLabel getFlowLabel() { result = taint() }
  }

  /**
   * A data flow sink for unsafe dynamic method access.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the flow label relevant for this sink
     */
    abstract DataFlow::FlowLabel getFlowLabel();
  }

  /**
   * A sanitizer for unsafe dynamic method access.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Gets the flow label describing values that may refer to an unsafe
   * function as a result of an attacker-controlled property name.
   */
  UnsafeFunction unsafeFunction() { any() }

  /**
   * A flow label describing values that may refer to an unsafe
   * function as a result of an attacker-controlled property name.
   */
  abstract class UnsafeFunction extends DataFlow::FlowLabel {
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

    override DataFlow::FlowLabel getFlowLabel() { result = unsafeFunction() }
  }
}
