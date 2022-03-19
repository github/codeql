import ruby
import codeql.ruby.ast.internal.Module as M

query predicate constantAccess(ConstantAccess a, string kind, string name, string cls) {
  (
    a instanceof ConstantReadAccess and kind = "read"
    or
    a instanceof ConstantWriteAccess and kind = "write"
  ) and
  name = a.getName() and
  cls = a.getAPrimaryQlClass()
}

query Expr getConst(Module m, string name) { result = M::ExposedForTestingOnly::getConst(m, name) }

query Expr lookupConst(Module m, string name) { result = M::lookupConst(m, name) }

query predicate constantValue(ConstantReadAccess a, Expr e) { e = a.getValue() }

query predicate constantWriteAccessQualifiedName(ConstantWriteAccess w, string qualifiedName) {
  w.getAQualifiedName() = qualifiedName
}
