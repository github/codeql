import rust
import codeql.rust.internal.TypeInference as TypeInference
import TypeInference
import utils.test.InlineExpectationsTest

query predicate inferType(AstNode n, TypePath path, Type t) {
  t = TypeInference::inferType(n, path)
}

query predicate resolveMethodCallExpr(MethodCallExpr mce, Function f) {
  f = resolveMethodCallExpr(mce)
}

query predicate resolveFieldExpr(FieldExpr fe, AstNode target) {
  target = resolveRecordFieldExpr(fe)
  or
  target = resolveTupleFieldExpr(fe)
}
