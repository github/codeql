import csharp
import semmle.code.csharp.commons.QualifiedName

private string getSignature(Method m) {
  exists(string qualifier, string name | m.getDeclaringType().hasQualifiedName(qualifier, name) |
    result = getQualifiedName(qualifier, name) + "." + m.toStringWithTypes()
  )
}

query predicate withExpr(WithExpr with, string type, Expr expr, ObjectInitializer init, string clone) {
  type = with.getType().toStringWithTypes() and
  expr = with.getExpr() and
  init = with.getInitializer() and
  clone = getSignature(with.getCloneMethod())
}

query predicate withTarget(WithExpr with, RecordCloneMethod clone, Constructor ctor) {
  with.getCloneMethod() = clone and
  clone.getConstructor() = ctor
}

query predicate cloneOverrides(string b, string o) {
  exists(RecordCloneMethod base, RecordCloneMethod overrider |
    base.getDeclaringType().fromSource() and
    base.getAnOverrider() = overrider and
    b = getSignature(base) and
    o = getSignature(overrider)
  )
}
