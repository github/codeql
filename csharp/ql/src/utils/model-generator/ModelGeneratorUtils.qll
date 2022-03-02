import csharp
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.commons.Util

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

class TargetAPI extends Callable {
  TargetAPI() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}

// BEGIN SECTION - More or less copied from FlowSummaries.ql
/** Gets the qualified parameter types of this callable as a comma-separated string. */
private string parameterQualifiedTypeNamesToString(TargetAPI api) {
  result =
    concat(Parameter p, int i |
      p = api.getParameter(i)
    |
      p.getType().getQualifiedName(), "," order by i
    )
}

/** Holds if the summary should apply for all overrides of this. */
private predicate isBaseCallableOrPrototype(TargetAPI api) {
  api.getDeclaringType() instanceof Interface
  or
  exists(Modifiable m | m = [api.(Modifiable), api.(Accessor).getDeclaration()] |
    m.isAbstract()
    or
    api.getDeclaringType().(Modifiable).isAbstract() and m.(Virtualizable).isVirtual()
  )
}

/** Gets a string representing, whether the summary should apply for all overrides of this. */
private string getCallableOverride(TargetAPI api) {
  if isBaseCallableOrPrototype(api) then result = "true" else result = "false"
}

/** Computes the first 6 columns for CSV rows. */
private string asPartialModel(TargetAPI api) {
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

// END SECTION
// BEGIN SECTION - Clean copy from ModelGeneratorUtils.ql
bindingset[input, output, kind]
string asSummaryModel(TargetAPI api, string input, string output, string kind) {
  result =
    asPartialModel(api) + input + ";" //
      + output + ";" //
      + kind
}

bindingset[input, output]
string asTaintModel(TargetAPI api, string input, string output) {
  result = asSummaryModel(api, input, output, "taint")
}

bindingset[input, output]
string asValueModel(TargetAPI api, string input, string output) {
  result = asSummaryModel(api, input, output, "value")
}

bindingset[input, kind]
string asSinkModel(TargetAPI api, string input, string kind) {
  result = asPartialModel(api) + input + ";" + kind
}

bindingset[output, kind]
string asSourceModel(TargetAPI api, string output, string kind) {
  result = asPartialModel(api) + output + ";" + kind
}

// END SECTION.
// TODO: Needs to be implemented property for C#.
predicate isPrimitiveTypeUsedForBulkData(Type t) {
  t.getName().regexpMatch("byte|char|Byte|Character")
}

// TODO: Needs to be implemented properly for C#.
// Sample below is just rudimentary.
// We at at least need something for Collection like type (ie IEnumerable and List)
predicate isRelevantType(Type t) {
  not t instanceof Enum and
  not t instanceof SimpleType and
  (
    not t.(ArrayType).getElementType() instanceof SimpleType or
    isPrimitiveTypeUsedForBulkData(t.(ArrayType).getElementType())
  )
}

// TODO: Is this propertly implemented?
predicate isRelevantTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(DataFlow::Content f |
    readStep(node1, f, node2) and
    if f instanceof DataFlow::FieldContent
    then isRelevantType(f.(DataFlow::FieldContent).getField().getType())
    else
      if f instanceof DataFlow::SyntheticFieldContent
      then isRelevantType(f.(DataFlow::SyntheticFieldContent).getField().getType())
      else any()
  )
  or
  exists(DataFlow::Content f | storeStep(node1, f, node2) | f instanceof DataFlow::ElementContent)
}

// TODO: Is this properly implemented?
predicate isRelevantContent(DataFlow::Content f) {
  isRelevantType(f.(DataFlow::FieldContent).getField().getType()) or
  f instanceof DataFlow::ElementContent
}

// TODO: Needs to be improved to handle more collection types that Array.
string parameterAccess(Parameter p) {
  if
    p.getType() instanceof ArrayType and
    not isPrimitiveTypeUsedForBulkData(p.getType().(ArrayType).getElementType())
  then result = "Argument[" + p.getPosition() + "].ArrayElement"
  else result = "Argument[" + p.getPosition() + "]"
}

// TODO: Is this properly implemented?
string parameterNodeAsInput(DataFlow::ParameterNode p) {
  result = parameterAccess(p.asParameter())
  or
  result = "Qualifier" and p instanceof InstanceParameterNode
}

// TODO: Is this properly implemented?
string returnNodeAsOutput(ReturnNodeExt node) {
  if node.getKind() instanceof ValueReturnKind
  then result = "ReturnValue"
  else
    exists(ParameterPosition pos | pos = node.getKind().(ParamUpdateReturnKind).getPosition() |
      result = parameterAccess(node.getEnclosingCallable().getParameter(pos.getPosition()))
      or
      pos.isThisParameter() and
      result = "Qualifier"
    )
}
