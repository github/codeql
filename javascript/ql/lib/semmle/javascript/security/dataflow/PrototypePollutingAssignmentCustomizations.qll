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
  /**
   * A data flow source for untrusted data from which the special `__proto__` property name may be arise.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for prototype-polluting assignments or untrusted property names.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * The flow label relevant for this sink.
     *
     * Use the `taint` label for untrusted property names, and the `ObjectPrototype` label for
     * object mutations.
     */
    abstract DataFlow::FlowLabel getAFlowLabel();
  }

  /**
   * A sanitizer for untrusted property names.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** Flow label representing the `Object.prototype` value. */
  abstract class ObjectPrototype extends DataFlow::FlowLabel {
    ObjectPrototype() { this = "Object.prototype" }
  }

  /** The base of an assignment or extend call, as a sink for `Object.prototype` references. */
  private class DefaultSink extends Sink {
    DefaultSink() {
      this = any(DataFlow::PropWrite write).getBase()
      or
      this = any(ExtendCall c).getDestinationOperand()
    }

    override DataFlow::FlowLabel getAFlowLabel() { result instanceof ObjectPrototype }
  }

  /** A remote flow source or location.{hash,search} as a taint source. */
  private class DefaultSource extends Source {
    DefaultSource() { this instanceof RemoteFlowSource }
  }
}
