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
 * 4. The sanitizing guards `TaintedObject::SanitizerGuard`.
 */

import javascript

module TaintedObject {
  private import DataFlow

  private class TaintedObjectLabel extends FlowLabel {
    TaintedObjectLabel() { this = "tainted-object" }
  }

  /**
   * Gets the flow label representing a deeply tainted object.
   *
   * A "tainted object" is an array or object whose property values are all assumed to be tainted as well.
   *
   * Note that the presence of the this label generally implies the presence of the `taint` label as well.
   */
  FlowLabel label() { result instanceof TaintedObjectLabel }

  /**
   * Holds for the flows steps that are relevant for tracking user-controlled JSON objects.
   */
  predicate step(Node src, Node trg, FlowLabel inlbl, FlowLabel outlbl) {
    // JSON parsers map tainted inputs to tainted JSON
    inlbl.isDataOrTaint() and
    outlbl = label() and
    exists(JsonParserCall parse |
      src = parse.getInput() and
      trg = parse.getOutput()
    )
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
    exists(ExtendCall call |
      src = call.getAnOperand() and
      trg = call
      or
      src = call.getASourceOperand() and
      trg = call.getDestinationOperand().getALocalSource()
    )
  }

  /**
   * Holds if `node` is a source of JSON taint and label is the JSON taint label.
   */
  predicate isSource(Node source, FlowLabel label) { source instanceof Source and label = label() }

  /**
   * A source of a user-controlled deep object.
   */
  abstract class Source extends DataFlow::Node { }

  /** Request input accesses as a JSON source. */
  private class RequestInputAsSource extends Source {
    RequestInputAsSource() { this.(HTTP::RequestInputAccess).isUserControlledObject() }
  }

  /**
   * Sanitizer guard that blocks deep object taint.
   */
  abstract class SanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode { }

  /**
   * A test of form `typeof x === "something"`, preventing `x` from being an object in some cases.
   */
  private class TypeTestGuard extends SanitizerGuard, ValueNode {
    override EqualityTest astNode;
    TypeofExpr typeof;
    boolean polarity;

    TypeTestGuard() {
      astNode.getAnOperand() = typeof and
      (
        // typeof x === "object" sanitizes `x` when it evaluates to false
        astNode.getAnOperand().getStringValue() = "object" and
        polarity = astNode.getPolarity().booleanNot()
        or
        // typeof x === "string" sanitizes `x` when it evaluates to true
        astNode.getAnOperand().getStringValue() != "object" and
        polarity = astNode.getPolarity()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e, FlowLabel label) {
      polarity = outcome and
      e = typeof.getOperand() and
      label = label()
    }
  }
}
