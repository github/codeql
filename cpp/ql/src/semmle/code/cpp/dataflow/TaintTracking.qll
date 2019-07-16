/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 *
 * We define _taint propagation_ informally to mean that a substantial part of
 * the information from the source is preserved at the sink. For example, taint
 * propagates from `x` to `x + 100`, but it does not propagate from `x` to `x >
 * 100` since we consider a single bit of information to be too little.
 */
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.dataflow.DataFlow2
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

module TaintTracking {

  /**
   * A configuration of interprocedural taint tracking analysis. This defines
   * sources, sinks, and any other configurable aspect of the analysis. Each
   * use of the taint tracking library must define its own unique extension of
   * this abstract class.
   *
   * A taint-tracking configuration is a special data flow configuration
   * (`DataFlow::Configuration`) that allows for flow through nodes that do not
   * necessarily preserve values but are still relevant from a taint-tracking
   * perspective. (For example, string concatenation, where one of the operands
   * is tainted.)
   *
   * To create a configuration, extend this class with a subclass whose
   * characteristic predicate is a unique singleton string. For example, write
   *
   * ```
   * class MyAnalysisConfiguration extends TaintTracking::Configuration {
   *   MyAnalysisConfiguration() { this = "MyAnalysisConfiguration" }
   *   // Override `isSource` and `isSink`.
   *   // Optionally override `isSanitizer`.
   *   // Optionally override `isSanitizerEdge`.
   *   // Optionally override `isAdditionalTaintStep`.
   * }
   * ```
   *
   * Then, to query whether there is flow between some `source` and `sink`,
   * write
   *
   * ```
   * exists(MyAnalysisConfiguration cfg | cfg.hasFlow(source, sink))
   * ```
   *
   * Multiple configurations can coexist, but it is unsupported to depend on a
   * `TaintTracking::Configuration` or a `DataFlow::Configuration` in the
   * overridden predicates that define sources, sinks, or additional steps.
   * Instead, the dependency should go to a `TaintTracking::Configuration2` or
   * a `DataFlow{2,3,4}::Configuration`.
   */
  abstract class Configuration extends DataFlow::Configuration {
    bindingset[this]
    Configuration() { any() }

    /** Holds if `source` is a taint source. */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSource(DataFlow::Node source);

    /** Holds if `sink` is a taint sink. */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSink(DataFlow::Node sink);

    /**
     * Holds if taint should not flow into `node`.
     */
    predicate isSanitizer(DataFlow::Node node) { none() }

    /** Holds if data flow from `node1` to `node2` is prohibited. */
    predicate isSanitizerEdge(DataFlow::Node node1, DataFlow::Node node2) {
      none()
    }

    /**
     * Holds if the additional taint propagation step
     * from `source` to `target` must be taken into account in the analysis.
     * This step will only be followed if `target` is not in the `isSanitizer`
     * predicate.
     */
    predicate isAdditionalTaintStep(DataFlow::Node source,
                                    DataFlow::Node target)
    { none() }

    final override
    predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    /** DEPRECATED: use `isSanitizerEdge` instead. */
    override deprecated
    predicate isBarrierEdge(DataFlow::Node node1, DataFlow::Node node2) {
      this.isSanitizerEdge(node1, node2)
    }

    final override
    predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node target) {
      this.isAdditionalTaintStep(source, target)
      or
      localTaintStep(source, target)
    }
  }

  /**
   * A taint-tracking configuration that is backed by the `DataFlow2` library
   * instead of `DataFlow`. Use this class when taint-tracking configurations
   * or data-flow configurations must depend on each other.
   *
   * See `TaintTracking::Configuration` for the full documentation.
   */
  abstract class Configuration2 extends DataFlow2::Configuration {
    bindingset[this]
    Configuration2() { any() }

    /** Holds if `source` is a taint source. */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSource(DataFlow::Node source);

    /** Holds if `sink` is a taint sink. */
    // overridden to provide taint-tracking specific qldoc
    abstract override predicate isSink(DataFlow::Node sink);

    /**
     * Holds if taint should not flow into `node`.
     */
    predicate isSanitizer(DataFlow::Node node) { none() }

    /** Holds if data flow from `node1` to `node2` is prohibited. */
    predicate isSanitizerEdge(DataFlow::Node node1, DataFlow::Node node2) {
      none()
    }

    /**
     * Holds if the additional taint propagation step
     * from `source` to `target` must be taken into account in the analysis.
     * This step will only be followed if `target` is not in the `isSanitizer`
     * predicate.
     */
    predicate isAdditionalTaintStep(DataFlow::Node source,
                                    DataFlow::Node target)
    { none() }

    final override
    predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    /** DEPRECATED: use `isSanitizerEdge` instead. */
    override deprecated
    predicate isBarrierEdge(DataFlow::Node node1, DataFlow::Node node2) {
      this.isSanitizerEdge(node1, node2)
    }

    final override
    predicate isAdditionalFlowStep(DataFlow::Node source, DataFlow::Node target) {
      this.isAdditionalTaintStep(source, target)
      or
      localTaintStep(source, target)
    }
  }

  /**
   * Holds if there is local taint flow from parameter `src` to parameter `dest`
   * of function `f`.
   */
  private predicate parameterTaintFlow(Function f, int src, int dest) {
    TaintTracking::localTaint(DataFlow::parameterNode(f.getParameter(src)),
      DataFlow::exprNode(f.getParameter(dest).getAnAssignedValue()))
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Taint can flow into using ordinary data flow.
    DataFlow::localFlowStep(nodeFrom, nodeTo)
    or
    // Taint can flow through expressions that alter the value but preserve
    // more than one bit of it _or_ expressions that follow data through
    // pointer indirections.
    exists(Expr exprFrom, Expr exprTo |
      exprFrom = nodeFrom.asExpr() and
      exprTo = nodeTo.asExpr()
    |
      exprFrom = exprTo.getAChild() and
      not noParentExprFlow(exprFrom, exprTo) and
      not noFlowFromChildExpr(exprTo)
      or
      // Taint can flow from the `x` variable in `x++` to all subsequent
      // accesses to the unmodified `x` variable.
      //
      // `DataFlow` without taint specifies flow from `++x` and `x += 1` into the
      // variable `x` and thus into subsequent accesses because those expressions
      // compute the same value as `x`. This is not the case for `x++`, which
      // computes a different value, so we have to add that ourselves for taint
      // tracking. The flow from expression `x` into `x++` etc. is handled in the
      // case above.
      exprTo = DataFlow::getAnAccessToAssignedVariable(
        exprFrom.(PostfixCrementOperation)
      )
    )
    or
    // Taint can flow through modeled functions
    exprToDefinitionByReferenceStep(nodeFrom.asExpr(), nodeTo.asDefiningArgument())
    or
    // Taint can flow between function arguments where there is data flow
    exists(Call call, int src, int dest |
      parameterTaintFlow(call.getTarget(), src, dest) and
      nodeFrom.asExpr() = call.getArgument(src) and
      nodeTo.asDefiningArgument() = call.getArgument(dest)
    )
  }

  /**
   * Holds if taint may propagate from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  predicate localTaint(DataFlow::Node source, DataFlow::Node sink) {
    localTaintStep*(source, sink)
  }

  /**
   * Holds if we do not propagate taint from `fromExpr` to `toExpr`
   * even though `toExpr` is the AST parent of `fromExpr`.
   */
  private predicate noParentExprFlow(Expr fromExpr, Expr toExpr) {
    fromExpr = toExpr.(ConditionalExpr).getCondition()
    or
    fromExpr = toExpr.(CommaExpr).getLeftOperand()
    or
    fromExpr = toExpr.(AssignExpr).getLValue() // LHS of `=`
  }

  /**
   * Holds if we do not propagate taint from a child of `e` to `e` itself.
   */
  private predicate noFlowFromChildExpr(Expr e) {
    e instanceof ComparisonOperation
    or
    e instanceof LogicalAndExpr
    or
    e instanceof LogicalOrExpr
    or
    e instanceof Call
    or
    e instanceof SizeofOperator
    or
    e instanceof AlignofOperator
  }

  private predicate exprToDefinitionByReferenceStep(Expr exprIn, Expr argOut) {
    exists(DataFlowFunction f, Call call, FunctionOutput outModel, int argOutIndex |
      call.getTarget() = f and
      argOut = call.getArgument(argOutIndex) and
      outModel.isOutParameterPointer(argOutIndex) and
      exists(int argInIndex, FunctionInput inModel |
        f.hasDataFlow(inModel, outModel)
      |
        // Taint flows from a pointer to a dereference, which DataFlow does not handle
        // memcpy(&dest_var, tainted_ptr, len)
        inModel.isInParameterPointer(argInIndex) and
        exprIn = call.getArgument(argInIndex)
      )
    )
    or
    exists(TaintFunction f, Call call, FunctionOutput outModel, int argOutIndex |
      call.getTarget() = f and
      argOut = call.getArgument(argOutIndex) and
      outModel.isOutParameterPointer(argOutIndex) and
      exists(int argInIndex, FunctionInput inModel |
        f.hasTaintFlow(inModel, outModel)
      |
        inModel.isInParameterPointer(argInIndex) and
        exprIn = call.getArgument(argInIndex)
        or
        inModel.isInParameterPointer(argInIndex) and
        call.passesByReference(argInIndex, exprIn)
        or
        inModel.isInParameter(argInIndex) and
        exprIn = call.getArgument(argInIndex)
      )
    )
  }
}
