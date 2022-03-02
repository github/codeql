import csharp
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.commons.Util

private Method superImpl(Method m) {
  result = m.getAnOverridee() and
  not exists(result.getAnOverridee()) and
  not m instanceof ToStringMethod
}

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

class TargetAPI extends Callable {
  TargetAPI() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}

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
