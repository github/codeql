import java

// Stop external filepaths from appearing in the results
class ClassOrInterfaceLocation extends ClassOrInterface {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(string fullPath | super.hasLocationInfo(fullPath, sl, sc, el, ec) |
      if exists(this.getFile().getRelativePath())
      then path = fullPath
      else path = fullPath.regexpReplaceAll(".*/", "<external>/")
    )
  }
}

query predicate delegatedProperties(
  DelegatedProperty dp, string name, string isLocal, Variable underlying, Expr initializer
) {
  (
    dp.isLocal() and isLocal = "local"
    or
    not dp.isLocal() and isLocal = "non-local"
  ) and
  underlying = dp.getDelegatee() and
  name = dp.getName() and
  underlying.getInitializer() = initializer
}

query predicate delegatedPropertyTypes(DelegatedProperty dp, Type type, Type underlyingType) {
  dp.getGetter().getReturnType() = type and
  dp.getDelegatee().getType() = underlyingType
}

query predicate delegatedPropertyGetters(DelegatedProperty dp, Method getter) {
  dp.getGetter() = getter
}

query predicate delegatedPropertySetters(DelegatedProperty dp, Method setter) {
  dp.getSetter() = setter
}
