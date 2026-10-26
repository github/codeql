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

query predicate rawTypeSupertypes(RawType rt, RefType superType) {
  rt.getFile().getURL().matches("%extlib%") and
  rt.getASupertype() = superType
}

query predicate rawTypeMethod(RefType rt, string name, string sig, string paramType, string retType) {
  exists(Method m | m.getDeclaringType() = rt and rt.getName().matches("RawTypesInSignature%") |
    name = m.getName() and
    sig = m.getSignature() and
    (
      if exists(m.getAParamType())
      then paramType = m.getAParamType().toString()
      else paramType = "No parameter"
    ) and
    retType = m.getReturnType().toString()
  )
}
