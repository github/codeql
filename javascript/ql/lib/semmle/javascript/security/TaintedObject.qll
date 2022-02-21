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
private import semmle.javascript.dataflow.InferredTypes

/** Provides classes and predicates for reasoning about deeply tainted objects. */
module TaintedObject {
  private import DataFlow
  import TaintedObjectCustomizations::TaintedObject

  // Materialize flow labels
  private class ConcreteTaintedObjectLabel extends TaintedObjectLabel {
    ConcreteTaintedObjectLabel() { this = this }
  }

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
    or
    // Spreading into an object preserves deep object taint: `p -> { ...p }`
    inlbl = label() and
    outlbl = label() and
    exists(ObjectLiteralNode obj |
      src = obj.getASpreadProperty() and
      trg = obj
    )
  }

  /**
   * Holds if `node` is a source of JSON taint and label is the JSON taint label.
   */
  predicate isSource(Node source, FlowLabel label) { source instanceof Source and label = label() }

  /** Request input accesses as a JSON source. */
  private class RequestInputAsSource extends Source {
    RequestInputAsSource() { this.(HTTP::RequestInputAccess).isUserControlledObject() }
  }

  /**
   * A sanitizer guard that blocks deep object taint.
   */
  abstract class SanitizerGuard extends TaintTracking::LabeledSanitizerGuardNode { }

  /**
   * A test of form `typeof x === "something"`, preventing `x` from being an object in some cases.
   */
  private class TypeTestGuard extends SanitizerGuard, ValueNode {
    override EqualityTest astNode;
    Expr operand;
    boolean polarity;

    TypeTestGuard() {
      exists(TypeofTag tag | TaintTracking::isTypeofGuard(astNode, operand, tag) |
        // typeof x === "object" sanitizes `x` when it evaluates to false
        tag = "object" and
        polarity = astNode.getPolarity().booleanNot()
        or
        // typeof x === "string" sanitizes `x` when it evaluates to true
        tag != "object" and
        polarity = astNode.getPolarity()
      )
    }

    override predicate sanitizes(boolean outcome, Expr e, FlowLabel label) {
      polarity = outcome and
      e = operand and
      label = label()
    }
  }

  /** A guard that checks whether `x` is a number. */
  class NumberGuard extends SanitizerGuard instanceof DataFlow::CallNode {
    Expr x;
    boolean polarity;

    NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

    override predicate sanitizes(boolean outcome, Expr e) { e = x and outcome = polarity }
  }

  /**
   * A sanitizer guard that validates an input against a JSON schema.
   */
  private class JsonSchemaValidationGuard extends SanitizerGuard {
    JsonSchema::ValidationCall call;
    boolean polarity;

    JsonSchemaValidationGuard() { this = call.getAValidationResultAccess(polarity) }

    override predicate sanitizes(boolean outcome, Expr e, FlowLabel label) {
      outcome = polarity and
      e = call.getInput().asExpr() and
      label = label()
    }
  }
}
