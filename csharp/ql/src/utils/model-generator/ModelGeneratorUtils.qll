import csharp
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate
private import semmle.code.csharp.frameworks.System

private Method superImpl(Method m) {
  result = m.getAnOverridee() and
  not exists(result.getAnOverridee()) and
  not m instanceof ToStringMethod
}

class TargetAPI extends Callable {
  TargetAPI() {
    this.(Member).isPublic() and
    this.fromSource() and
    (
      this.getDeclaringType().isPublic() or
      superImpl(this).getDeclaringType().isPublic()
    ) and
    isRelevantForModels(this)
  }
}

// Needs to be implemented
private predicate isRelevantForModels(Callable api) { any() }
