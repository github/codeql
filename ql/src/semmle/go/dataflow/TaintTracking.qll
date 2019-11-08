/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import go

module TaintTracking {
  private import semmle.go.dataflow.internal.DataFlowPrivate
  private import semmle.go.dataflow.FunctionInputsAndOutputs

  /**
   * Holds if taint propagates from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Ordinary data flow
    DataFlow::localFlowStep(nodeFrom, nodeTo)
    or
    taintStep(nodeFrom, nodeTo)
  }

  /**
   * A taint tracking configuration.
   *
   * A taint tracking configuration is a special data flow configuration
   * (`DataFlow::Configuration`) that allows for flow through nodes that do not
   * necessarily preserve values, but are still relevant from a taint tracking
   * perspective. (For example, string concatenation, where one of the operands
   * is tainted.)
   *
   * Each use of the taint tracking library must define its own unique extension
   * of this abstract class. A configuration defines a set of relevant sources
   * (`isSource`) and sinks (`isSink`), and may additionally treat intermediate
   * nodes as "sanitizers" (`isSanitizer`) as well as add custom taint flow steps
   * (`isAdditionalTaintStep()`).
   */
  abstract class Configuration extends DataFlow::Configuration {
    bindingset[this]
    Configuration() { any() }

    /**
     * Holds if `source` is a relevant taint source.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSource(DataFlow::Node source);

    /**
     * Holds if `sink` is a relevant taint sink.
     *
     * The smaller this predicate is, the faster `hasFlow()` will converge.
     */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSink(DataFlow::Node sink);

    /** Holds if the intermediate node `node` is a taint sanitizer. */
    predicate isSanitizer(DataFlow::Node node) { none() }

    final override predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    /**
     * Holds if the additional taint propagation step from `pred` to `succ`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    final override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      isAdditionalTaintStep(pred, succ)
      or
      taintStep(pred, succ)
    }

    /**
     * Holds if taint may flow from `source` to `sink` for this configuration.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink)
    }
  }

  /**
   * Holds if taint flows from `pred` to `succ` in one step.
   */
  private predicate taintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // if x is tainted, then so is &x
    succ.asExpr().(AddressExpr).getOperand() = pred.asExpr()
    or
    // if x is tainted, then so is *x
    succ.asExpr().(StarExpr).getBase() = pred.asExpr()
    or
    // if an array is tainted, then so are all its elements
    succ.asExpr().(IndexExpr).getBase() = pred.asExpr()
    or
    // if a tuple is tainted, then so are all its components
    succ = DataFlow::extractTupleElement(pred, _)
    or
    // taint propagates through string concatenation
    succ.asExpr().(AddExpr).getAnOperand() = pred.asExpr()
    or
    // taint propagates through slicing
    succ.asExpr().(SliceExpr).getBase() = pred.asExpr()
    or
    // step through function model
    exists(FunctionModel m, DataFlow::CallNode c, FunctionInput inp, FunctionOutput outp |
      c = m.getACall() and
      m.hasTaintFlow(inp, outp) and
      pred = inp.getNode(c) and
      succ = outp.getNode(c)
    )
  }

  /**
   * A model of a function specifying that the function propagates taint from
   * a parameter or qualifier to a result.
   */
  abstract class FunctionModel extends Function {
    abstract predicate hasTaintFlow(FunctionInput input, FunctionOutput output);
  }
}
