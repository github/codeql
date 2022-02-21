import java
import semmle.code.java.dataflow.internal.DataFlowPrivate

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
  LocalVariableDecl decl, RefType t1, RefType t2, RefType t3, boolean compatible
) {
  decl.getType() = t1 and
  decl.getInitializer().getType() = t2 and
  t2.extendsOrImplements(t3) and
  (
    compatible = true and compatibleTypes(t1, t2)
    or
    compatible = false and not compatibleTypes(t1, t2)
  )
}

query predicate invocation(Call c, Callable callee) {
  c.getCallee() = callee and callee.getDeclaringType().getPackage().getName() = "kotlin.reflect"
}
