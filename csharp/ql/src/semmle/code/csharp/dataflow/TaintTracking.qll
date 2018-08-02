/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import csharp

module TaintTracking {
   private import semmle.code.csharp.dataflow.LibraryTypeDataFlow
   private import semmle.code.csharp.dispatch.Dispatch
   private import semmle.code.csharp.commons.ComparisonTest
   private import cil
   private import dotnet

  /**
   * Holds if taint propagates from `source` to `sink` in zero or more local
   * (intra-procedural) steps.
   */
  predicate localTaint(DataFlow::Node source, DataFlow::Node sink) {
    localTaintStep*(source, sink)
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Ordinary data flow
    DataFlow::localFlowStep(nodeFrom, nodeTo)
    or
    localAdditionalTaintStep(nodeFrom, nodeTo)
  }

  private CIL::DataFlowNode asCilDataFlowNode(DataFlow::Node node) {
    result = node.asParameter() or
    result = node.asExpr()
  }

  private predicate localTaintStepCil(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    asCilDataFlowNode(nodeFrom).getALocalFlowSucc(asCilDataFlowNode(nodeTo), any(CIL::Tainted t))
  }

  private cached predicate localAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    localAdditionalTaintStepExpr(nodeFrom.asExpr(), nodeTo.asExpr())
    or
    DataFlow::Internal::flowOutOfDelegateLibraryCall(nodeFrom, nodeTo, false)
    or
    // Taint from `foreach` expression
    exists(ForeachStmt fs, AssignableDefinitions::LocalVariableDefinition def, Ssa::ExplicitDefinition ssaDef |
      nodeFrom.asExpr() = fs.getIterableExpr() and
      def.getTarget() = fs.getVariable() and
      ssaDef.getADefinition() = def and
      nodeTo.(DataFlow::Internal::SsaDefinitionNode).getDefinition() = ssaDef
    )
    or
    localTaintStepCil(nodeFrom, nodeTo)
  }

  private predicate localAdditionalTaintStepExpr(Expr exprFrom, Expr exprTo) {
    // Taint propagation using library code
    libraryFlow(exprFrom, exprTo, false)
    or
    // Taint from assigned value to element qualifier (`x[i] = 0`)
    exists(AssignExpr ae |
      exprFrom = ae.getRValue() and
      exprTo.(AssignableRead) = getElementAccessQualifier+(ae.getLValue())
    )
    or
    // Taint from array initializer
    exprFrom = exprTo.(ArrayCreation).getInitializer().getAnElement()
    or
    // Taint from object initializer
    exists(ElementInitializer ei |
      ei = exprTo.(ObjectCreation).getInitializer().(CollectionInitializer).getAnElementInitializer() and
      exprFrom = ei.getArgument(ei.getNumberOfArguments() - 1) // assume the last argument is the value (i.e., not a key)
    )
    or
    // Taint from element qualifier
    exprFrom = exprTo.(ElementAccess).getQualifier()
    or
    exprFrom = exprTo.(AddExpr).getAnOperand()
    or
    // A comparison expression where taint can flow from one of the
    // operands if the other operand is a constant value.
    exists(ComparisonTest ct, Expr other |
      ct.getExpr() = exprTo and
      exprFrom = ct.getAnArgument() and
      other = ct.getAnArgument() and
      other.stripCasts().hasValue() and
      exprFrom != other
    )
    or
    exprFrom = exprTo.(LogicalOperation).getAnOperand()
    or
    // Taint from tuple argument
    exprTo = any(TupleExpr te |
      exprFrom = te.getAnArgument() and
      te.isReadAccess()
    )
    or
    exprFrom = exprTo.(InterpolatedStringExpr).getAChild()
    or
    // Taint from tuple expression
    exprTo = any(MemberAccess ma |
      ma.getQualifier().getType() instanceof TupleType and
      exprFrom = ma.getQualifier()
    )
  }

  /** Gets the qualifier of element access `ea`. */
  private Expr getElementAccessQualifier(ElementAccess ea) {
    result = ea.getQualifier()
  }

  /**
   * A taint tracking configuration.
   *
   * A taint tracking configuration is a special dataflow configuration
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

    final
    override predicate isBarrier(DataFlow::Node node) { isSanitizer(node) }

    /**
     * Holds if the additional taint propagation step from `pred` to `succ`
     * must be taken into account in the analysis.
     */
    predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) { none() }

    final
    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      isAdditionalTaintStep(pred, succ) or
      localAdditionalTaintStep(pred, succ) or
      DataFlow::Internal::flowThroughCallableLibraryOutRef(_, pred.asExpr(), succ, false)
    }

    final
    override predicate isAdditionalFlowStepIntoCall(DataFlow::Node call, DataFlow::Node arg, DotNet::Parameter p, CallContext::CallContext cc) {
      DataFlow::Internal::flowIntoCallableLibraryCall(_, arg, call, p, false, cc)
    }

    final
    override predicate isAdditionalFlowStepOutOfCall(DataFlow::Node call, DataFlow::Node ret, DataFlow::Node out, CallContext::CallContext cc) {
      exists(DispatchCall dc, Callable callable |
        canYieldReturn(callable, ret.asExpr()) |
        dc.getCall() = call.asExpr() and
        call = out and
        callable = dc.getADynamicTarget() and
        cc instanceof CallContext::EmptyCallContext
      )
    }

    /**
     * Holds if taint may flow from `source` to `sink` for this configuration.
     */
    // overridden to provide taint-tracking specific qldoc
    override predicate hasFlow(DataFlow::Node source, DataFlow::Node sink) {
      super.hasFlow(source, sink)
    }
  }

  private predicate canYieldReturn(Callable c, Expr e) {
    c.getSourceDeclaration().canYieldReturn(e)
  }
}
