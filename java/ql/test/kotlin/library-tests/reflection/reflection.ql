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

class CallableLocation extends Callable {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(string fullPath | super.hasLocationInfo(fullPath, sl, sc, el, ec) |
      if exists(this.getFile().getRelativePath())
      then path = fullPath
      else path = fullPath.regexpReplaceAll(".*/", "<external>/")
    )
  }
}

query predicate variableInitializerType(
  LocalVariableDecl decl, RefType t1, RefType t2, RefType t3, boolean implements
) {
  decl.getType() = t1 and
  decl.getInitializer().getType() = t2 and
  t2.extendsOrImplements(t3) and
  (
    implements = true and t2.extendsOrImplements+(t1)
    or
    implements = false and not t2.extendsOrImplements+(t1)
  )
}

query predicate invocation(Call c, Callable callee) {
  c.getCallee() = callee and callee.getDeclaringType().getPackage().getName() = "kotlin.reflect"
}
