/**
 * Provides methods for reasoning about the flow of deeply tainted objects, such as JSON objects
 * parsed from user-controlled data.
 *
 * Deeply tainted objects are arrays or objects with user-controlled property names, containing
 * tainted values or deeply tainted objects in their properties.
 *
 * To track deeply tainted objects, a flow-tracking configuration should generally include the following:
 *
 * 1. One or more sinks associated with the label `TaintedObject::label()`.
 * 2. The sources from `TaintedObject::isSource`.
 * 3. The flow steps from `TaintedObject::step`.
 */
import javascript

module TaintedObject {
  private import DataFlow

  private class TaintedObjectLabel extends FlowLabel {
    TaintedObjectLabel() { this = "tainted-object" }
  }

  /**
   * Gets the flow label representing a deeply tainted objects.
   *
   * A "tainted object" is an array or object whose values are all assumed to be tainted as well.
   *
   * Note that the presence of the `object-taint` label generally implies the presence of the `taint` label as well.
   */
  FlowLabel label() { result instanceof TaintedObjectLabel  }

  /**
   * Holds for the flows steps that are relevant for tracking user-controlled JSON objects.
   */
  predicate step(Node src, Node trg, FlowLabel inlbl, FlowLabel outlbl) {
    // JSON parsers map tainted inputs to tainted JSON
    (inlbl = FlowLabel::data() or inlbl = FlowLabel::taint()) and
    outlbl = label() and
    exists (JsonParserCall parse |
      src = parse.getInput() and
      trg = parse.getOutput())
    or
    // Property reads preserve deep object taint.
    inlbl = label() and
    outlbl = label() and
    trg.(PropRead).getBase() = src
    or
    // Property projection preserves deep object taint
    inlbl = label() and
    outlbl = label() and
    trg.(PropertyProjection).getObject() = src
    or
    // Extending objects preserves deep object taint
    inlbl = label() and
    outlbl = label() and
    exists (ExtendCall call |
      src = call.getAnOperand() and
      trg = call
      or
      src = call.getASourceOperand() and
      trg = call.getDestinationOperand().getALocalSource())
  }

  /**
   * Holds if `node` is a source of JSON taint and label is the JSON taint label.
   */
  predicate isSource(Node source, FlowLabel label) {
    source instanceof Source and label = label()
  }

  /**
   * A source of a user-controlled deep object object.
   */
  abstract class Source extends DataFlow::Node {}

  /** Request input accesses as a JSON source. */
  private class RequestInputAsSource extends Source {
    RequestInputAsSource() {
      this.(HTTP::RequestInputAccess).isDeepObject()
    }
  }

  // TODO: string tests should be classified as sanitizer guards; need support for flow labels on guards
}
