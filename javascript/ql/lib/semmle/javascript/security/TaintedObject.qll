/**
 * Provides methods for reasoning about the flow of deeply tainted objects, such as JSON objects
 * parsed from user-controlled data.
 *
 * Deeply tainted objects are arrays or objects with user-controlled property names, containing
 * tainted values or deeply tainted objects in their properties.
 *
 * To track deeply tainted objects, a flow-tracking configuration should generally include the following:
 *
 * 1. One or more sinks associated with the flow state `FlowState::taintedObject()`.
 * 2. The sources from `TaintedObject::Source`.
 * 3. The flow steps from `TaintedObject::isAdditionalFlowStep`.
 * 4. The barriers from `TaintedObject::SanitizerGuard::getABarrierNode(state)`.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/** Provides classes and predicates for reasoning about deeply tainted objects. */
module TaintedObject {
  private import DataFlow
  import TaintedObjectCustomizations::TaintedObject

  // Materialize flow labels
  deprecated private class ConcreteTaintedObjectLabel extends TaintedObjectLabel {
    ConcreteTaintedObjectLabel() { this = this }
  }

  /**
   * DEPRECATED. Use `isAdditionalFlowStep(node1, state1, node2, state2)` instead.
   */
  deprecated predicate step(Node src, Node trg, FlowLabel inlbl, FlowLabel outlbl) {
    isAdditionalFlowStep(src, FlowState::fromFlowLabel(inlbl), trg, FlowState::fromFlowLabel(outlbl))
  }

  /**
   * Holds for the flows steps that are relevant for tracking user-controlled JSON objects.
   */
  predicate isAdditionalFlowStep(Node node1, FlowState state1, Node node2, FlowState state2) {
    // JSON parsers map tainted inputs to tainted JSON
    state1.isTaint() and
    state2.isTaintedObject() and
    exists(JsonParserCall parse |
      node1 = parse.getInput() and
      node2 = parse.getOutput()
    )
    or
    // Property reads preserve deep object taint.
    state1.isTaintedObject() and
    state2.isTaintedObject() and
    node2.(PropRead).getBase() = node1
    or
    // Property projection preserves deep object taint
    state1.isTaintedObject() and
    state2.isTaintedObject() and
    node2.(PropertyProjection).getObject() = node1
    or
    // Extending objects preserves deep object taint
    state1.isTaintedObject() and
    state2.isTaintedObject() and
    exists(ExtendCall call |
      node1 = call.getAnOperand() and
      node2 = call
      or
      node1 = call.getASourceOperand() and
      node2 = call.getDestinationOperand().getALocalSource()
    )
    or
    // Spreading into an object preserves deep object taint: `p -> { ...p }`
    state1.isTaintedObject() and
    state2.isTaintedObject() and
    exists(ObjectLiteralNode obj |
      node1 = obj.getASpreadProperty() and
      node2 = obj
    )
  }

  /**
   * DEPRECATED. Use the `Source` class and `FlowState#isTaintedObject()` directly.
   *
   * Holds if `node` is a source of JSON taint and label is the JSON taint label.
   */
  deprecated predicate isSource(Node source, FlowLabel label) {
    source instanceof Source and label = label()
  }

  /** Request input accesses as a JSON source. */
  private class RequestInputAsSource extends Source {
    RequestInputAsSource() { this.(Http::RequestInputAccess).isUserControlledObject() }
  }

  /**
   * A sanitizer guard that blocks deep object taint.
   */
  abstract class SanitizerGuard extends DataFlow::Node {
    /** Holds if this node blocks flow through `e`, provided it evaluates to `outcome`. */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /** Holds if this node blocks flow of `state` through `e`, provided it evaluates to `outcome`. */
    predicate blocksExpr(boolean outcome, Expr e, FlowState state) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e, FlowLabel label) {
      this.blocksExpr(outcome, e, FlowState::fromFlowLabel(label))
    }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }
  }

  deprecated private class SanitizerGuardLegacy extends TaintTracking::LabeledSanitizerGuardNode instanceof SanitizerGuard
  {
    deprecated override predicate sanitizes(boolean outcome, Expr e, FlowLabel label) {
      SanitizerGuard.super.sanitizes(outcome, e, label)
    }

    deprecated override predicate sanitizes(boolean outcome, Expr e) {
      SanitizerGuard.super.sanitizes(outcome, e)
    }
  }

  /**
   * A sanitizer guard that blocks deep object taint.
   */
  module SanitizerGuard = DataFlow::MakeStateBarrierGuard<FlowState, SanitizerGuard>;

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

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      polarity = outcome and
      e = operand and
      state.isTaintedObject()
    }
  }

  /** A guard that checks whether `x` is a number. */
  class NumberGuard extends SanitizerGuard instanceof DataFlow::CallNode {
    Expr x;
    boolean polarity;

    NumberGuard() { TaintTracking::isNumberGuard(this, x, polarity) }

    override predicate blocksExpr(boolean outcome, Expr e) { e = x and outcome = polarity }
  }

  /** A guard that checks whether an input a valid string identifier using `mongoose.Types.ObjectId.isValid` */
  class ObjectIdGuard extends SanitizerGuard instanceof API::CallNode {
    ObjectIdGuard() {
      this =
        API::moduleImport("mongoose")
            .getMember("Types")
            .getMember("ObjectId")
            .getMember("isValid")
            .getACall()
    }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      e = super.getAnArgument().asExpr() and outcome = true and state.isTaintedObject()
    }
  }

  /**
   * A sanitizer guard that validates an input against a JSON schema.
   */
  private class JsonSchemaValidationGuard extends SanitizerGuard {
    JsonSchema::ValidationCall call;
    boolean polarity;

    JsonSchemaValidationGuard() { this = call.getAValidationResultAccess(polarity) }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      outcome = polarity and
      e = call.getInput().asExpr() and
      state.isTaintedObject()
    }
  }
}
