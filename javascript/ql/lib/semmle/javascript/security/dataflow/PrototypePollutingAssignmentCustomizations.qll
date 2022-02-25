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
    abstract DataFlow::FlowLabel getAFlowLabel();
  }

  /**
   * A sanitizer for untrusted property names.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A flow label representing the `Object.prototype` value. */
  abstract class ObjectPrototype extends DataFlow::FlowLabel {
    ObjectPrototype() { this = "Object.prototype" }
  }

  /** The base of an assignment or extend call, as a sink for `Object.prototype` references. */
  private class DefaultSink extends Sink {
    DefaultSink() {
      this = any(DataFlow::PropWrite write).getBase()
      or
      this = any(ExtendCall c).getDestinationOperand()
      or
      this = any(DeleteExpr del).getOperand().flow().(DataFlow::PropRef).getBase()
    }

    override DataFlow::FlowLabel getAFlowLabel() { result instanceof ObjectPrototype }
  }

  /** A remote flow source or location.{hash,search} as a taint source. */
  private class DefaultSource extends Source {
    DefaultSource() { this instanceof RemoteFlowSource }

    override string describe() { result = "user controlled input" }
  }

  import semmle.javascript.PackageExports as Exports

  /**
   * A parameter of an exported function, seen as a source prototype-polluting assignment.
   */
  class ExternalInputSource extends Source, DataFlow::SourceNode {
    ExternalInputSource() { this = Exports::getALibraryInputParameter() }

    override string describe() { result = "library input" }
  }
}
