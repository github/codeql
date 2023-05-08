private import javascript
private import VariableTypeInference

/**
 * Holds if `p` is analyzed precisely by the type inference.
 */
pragma[nomagic]
predicate isAnalyzedParameter(Parameter p) {
  exists(FunctionWithAnalyzedParameters f | p = f.getAParameter() |
    // we cannot track flow into rest parameters
    not p.isRestParameter()
  )
}

/**
 * A parameter whose value is propagated interprocedurally.
 */
class AnalyzedParameter extends AnalyzedValueNode {
  override Parameter astNode;

  AnalyzedParameter() { isAnalyzedParameter(astNode) }

  FunctionWithAnalyzedParameters getFunction() { astNode = result.getAParameter() }

  override AbstractValue getALocalValue() {
    exists(DataFlow::AnalyzedNode pred |
      this.getFunction().argumentPassing(astNode, pred.asExpr()) and
      result = pred.getALocalValue()
    )
    or
    not this.getFunction().mayReceiveArgument(astNode) and
    result = TAbstractUndefined()
    or
    result = astNode.getDefault().analyze().getALocalValue()
  }

  override predicate hasAdditionalIncompleteness(DataFlow::Incompleteness cause) {
    this.getFunction().isIncomplete(cause)
    or
    not this.getFunction().argumentPassing(astNode, _) and
    this.getFunction().mayReceiveArgument(astNode) and
    cause = "call"
  }
}
