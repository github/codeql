import csharp
import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.commons.Util
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

/**
 * A class of Callables that are relevant for generating summary, source and sinks models for.
 *
 * In the Standard library and 3rd party libraries it the Callables that can be called
 * from outside the library itself.
 */
class TargetApi extends Callable {
  TargetApi() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}

private string parameterQualifiedTypeNamesToString(TargetApi api) {
  result =
    concat(Parameter p, int i |
      p = api.getParameter(i)
    |
      p.getType().getQualifiedName(), "," order by i
    )
}

/** Holds if the summary should apply for all overrides of this. */
private predicate isBaseCallableOrPrototype(TargetApi api) {
  api.getDeclaringType() instanceof Interface
  or
  exists(Modifiable m | m = [api.(Modifiable), api.(Accessor).getDeclaration()] |
    m.isAbstract()
    or
    api.getDeclaringType().(Modifiable).isAbstract() and m.(Virtualizable).isVirtual()
  )
}

/** Gets a string representing whether the summary should apply for all overrides of this. */
private string getCallableOverride(TargetApi api) {
  if isBaseCallableOrPrototype(api) then result = "true" else result = "false"
}

/** Computes the first 6 columns for CSV rows. */
string asPartialModel(TargetApi api) {
  exists(string namespace, string type |
    api.getDeclaringType().hasQualifiedName(namespace, type) and
    result =
      namespace + ";" //
        + type + ";" //
        + getCallableOverride(api) + ";" //
        + api.getName() + ";" //
        + "(" + parameterQualifiedTypeNamesToString(api) + ")" //
        + /* ext + */ ";" //
  )
}

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
