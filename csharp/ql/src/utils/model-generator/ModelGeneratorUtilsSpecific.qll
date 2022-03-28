import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.commons.Util
private import semmle.code.csharp.commons.Collections
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

/**
 * A class of callables that are relevant generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the callables that can be called
 * from outside the library itself.
 */
class TargetApi extends DataFlowCallable {
  TargetApi() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}

predicate asPartialModel = Csv::asPartialModel/1;

/**
 * Holds for type `t` for fields that are relevant as an intermediate
 * read or write step in the data flow analysis.
 */
predicate isRelevantType(Type t) { not t instanceof Enum }

private string parameterAccess(Parameter p) {
  if isCollectionType(p.getType())
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

pragma[nomagic]
private Parameter getParameter(ReturnNodeExt node, ParameterPosition pos) {
  result = node.getEnclosingCallable().getParameter(pos.getPosition())
}

/**
 * Gets the model string represention of the the return node `node`.
 */
string returnNodeAsOutput(ReturnNodeExt node) {
  if node.getKind() instanceof ValueReturnKind
  then result = "ReturnValue"
  else
    exists(ParameterPosition pos | pos = node.getKind().(ParamUpdateReturnKind).getPosition() |
      result = parameterAccess(getParameter(node, pos))
      or
      pos.isThisParameter() and
      result = "Argument[Qualifier]"
    )
}
