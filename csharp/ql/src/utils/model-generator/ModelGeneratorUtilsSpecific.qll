import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.commons.Util
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

/**
 * A class of DataFlowCallables that are relevant for generating summary, source and sinks models.
 *
 * In the Standard library and 3rd party libraries it the Callables that can be called
 * from outside the library itself.
 */
class TargetApi extends DataFlowCallable {
  TargetApi() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}

/** Computes the first 6 columns for CSV rows. */
string asPartialModel(TargetApi api) { result = api.asPartialModel() }

/**
 * Holds for type `t` for fields that are relevant as an intermediate
 * read or write step in the data flow analysis.
 */
predicate isRelevantType(Type t) { not t instanceof Enum }

private predicate isPrimitiveTypeUsedForBulkData(Type t) {
  t.getName().regexpMatch("byte|char|Byte|Char")
}

private string parameterAccess(Parameter p) {
  if
    p.getType() instanceof ArrayType and
    not isPrimitiveTypeUsedForBulkData(p.getType().(ArrayType).getElementType())
  then result = "Argument[" + p.getPosition() + "].Element"
  else result = "Argument[" + p.getPosition() + "]"
}

/**
 * Gets the model string representation of the parameter node `p`.
 */
string parameterNodeAsInput(DataFlow::ParameterNode p) {
  result = parameterAccess(p.asParameter())
  or
  result = "Argument[Qualifier]" and p instanceof InstanceParameterNode
}

/**
 * Gets the model string represention of the the return node `node`.
 */
string returnNodeAsOutput(ReturnNodeExt node) {
  if node.getKind() instanceof ValueReturnKind
  then result = "ReturnValue"
  else
    exists(ParameterPosition pos | pos = node.getKind().(ParamUpdateReturnKind).getPosition() |
      result = parameterAccess(node.getEnclosingCallable().getParameter(pos.getPosition()))
      or
      pos.isThisParameter() and
      result = "Argument[Qualifier]"
    )
}
