private import go

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
predicate localTaint(DataFlow::Node src, DataFlow::Node sink) { localTaintStep*(src, sink) }

/**
 * Holds if taint can flow from `src` to `sink` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprTaint(Expr src, Expr sink) {
  localTaint(DataFlow::exprNode(src), DataFlow::exprNode(sink))
}

/**
 * Holds if taint can flow in one local step from `src` to `sink`.
 */
predicate localTaintStep(DataFlow::Node src, DataFlow::Node sink) {
  DataFlow::localFlowStep(src, sink) or
  localAdditionalTaintStep(src, sink)
}

private newtype TUnit = TMkUnit()

/** A singleton class containing a single dummy "unit" value. */
private class Unit extends TUnit {
  /** Gets a textual representation of this element. */
  string toString() { result = "unit" }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * Holds if the additional step from `pred` to `succ` should be included in all
 * global taint flow configurations.
 */
predicate localAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  referenceStep(pred, succ) or
  fieldReadStep(pred, succ) or
  arrayStep(pred, succ) or
  tupleStep(pred, succ) or
  stringConcatStep(pred, succ) or
  sliceStep(pred, succ) or
  functionModelStep(_, pred, succ) or
  any(AdditionalTaintStep a).step(pred, succ)
}

/** Holds if taint flows from `pred` to `succ` via a reference or dereference. */
predicate referenceStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::AddressOperationNode).getOperand() = pred
  or
  succ.(DataFlow::PointerDereferenceNode).getOperand() = pred
}

/** Holds if taint flows from `pred` to `succ` via a field read. */
predicate fieldReadStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::FieldReadNode).getBase() = pred
}

/** Holds if taint flows from `pred` to `succ` via an array index operation. */
predicate arrayStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::ElementReadNode).getBase() = pred
}

/** Holds if taint flows from `pred` to `succ` via an extract tuple operation. */
predicate tupleStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ = DataFlow::extractTupleElement(pred, _)
}

/** Holds if taint flows from `pred` to `succ` via string concatenation. */
predicate stringConcatStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::BinaryOperationNode conc |
    conc.getOperator() = "+" and conc.getType() instanceof StringType |
    succ = conc and conc.getAnOperand() = pred
  )
}

/** Holds if taint flows from `pred` to `succ` via a slice operation. */
predicate sliceStep(DataFlow::Node pred, DataFlow::Node succ) {
  succ.(DataFlow::SliceNode).getBase() = pred
}

/** Holds if taint flows from `pred` to `succ` via a function model. */
predicate functionModelStep(FunctionModel fn, DataFlow::Node pred, DataFlow::Node succ) {
  exists(DataFlow::CallNode c, FunctionInput inp, FunctionOutput outp |
    c = fn.getACall() and
    fn.hasTaintFlow(inp, outp) and
    pred = inp.getNode(c) and
    succ = outp.getNode(c)
  )
}

/**
 * A model of a function specifying that the function propagates taint from
 * a parameter or qualifier to a result.
 */
abstract class FunctionModel extends Function {
  /** Holds if taint propagates through this function from `input` to `output`. */
  abstract predicate hasTaintFlow(FunctionInput input, FunctionOutput output);
}

/**
 * Holds if the additional step from `src` to `sink` should be included in all
 * global taint flow configurations.
 */
predicate defaultAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {
  localAdditionalTaintStep(src, sink)
}

/**
 * Holds if `node` should be a barrier in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintBarrier(DataFlow::Node node) { none() }
