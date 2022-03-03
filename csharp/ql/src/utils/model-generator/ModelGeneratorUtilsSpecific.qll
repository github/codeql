import csharp
private import semmle.code.csharp.commons.Util

private predicate isRelevantForModels(Callable api) { not api instanceof MainMethod }

class TargetAPI extends Callable {
  TargetAPI() {
    [this.(Modifiable), this.(Accessor).getDeclaration()].isEffectivelyPublic() and
    this.fromSource() and
    isRelevantForModels(this)
  }
}
