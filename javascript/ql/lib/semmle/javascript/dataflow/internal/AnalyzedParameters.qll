private import javascript
private import VariableTypeInference

/**
 * Holds if `p` is analyzed precisely by the type inference.
 */
pragma[nomagic]
predicate isAnalyzedParameter(Parameter p) {
  exists(FunctionWithAnalyzedParameters f, int parmIdx | p = f.getParameter(parmIdx) |
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
      getFunction().argumentPassing(astNode, pred.asExpr()) and
      result = pred.getALocalValue()
    )
    or
    not getFunction().mayReceiveArgument(astNode) and
    result = TAbstractUndefined()
    or
    result = astNode.getDefault().analyze().getALocalValue()
  }

  override predicate hasAdditionalIncompleteness(DataFlow::Incompleteness cause) {
    getFunction().isIncomplete(cause)
    or
    not getFunction().argumentPassing(astNode, _) and
    getFunction().mayReceiveArgument(astNode) and
    cause = "call"
  }
}
