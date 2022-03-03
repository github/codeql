import csharp
private import semmle.code.csharp.commons.Util
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

class TargetAPI extends Callable {
  TargetAPI() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}

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
string asPartialModel(TargetAPI api) {
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

predicate isRelevantType(Type t) { not t instanceof Enum }

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

predicate isRelevantContent(DataFlow::Content f) {
  isRelevantType(f.(DataFlow::FieldContent).getField().getType()) or
  f instanceof DataFlow::ElementContent
}
