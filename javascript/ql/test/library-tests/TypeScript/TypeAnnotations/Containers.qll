import javascript

abstract class Violation extends ASTNode {
  abstract string reason();
}

class MissingContainer extends Violation, TypeExpr {
  MissingContainer() { not exists(getContainer()) }

  override string reason() { result = "Has no container" }
}

class MissingEnclosingStmt extends Violation, TypeExpr {
  MissingEnclosingStmt() {
    not exists(getEnclosingStmt()) and
    // type parameters, parameter types, return types, and this parameter types have no enclosing statements
    not exists(Function f, TypeExpr type |
      (
        type = f.getAParameter().getTypeAnnotation() or
        type = f.getReturnTypeAnnotation() or
        type = f.getATypeParameter() or
        type = f.getThisTypeAnnotation()
      ) and
      this.getParent*() = type
    )
  }

  override string reason() { result = "Has no enclosing statement" }
}

class DifferentContainer extends Violation, VarDecl {
  DifferentContainer() { getContainer() != getTypeAnnotation().getContainer() }

  override string reason() { result = "Type annotation has different container" }
}

class DifferentEnclosingStmt extends Violation, VarDecl {
  DifferentEnclosingStmt() { getEnclosingStmt() != getTypeAnnotation().getEnclosingStmt() }

  override string reason() { result = "Type annotation has different enclosing statement" }
}

query predicate test_Containers(Violation err, string res) { res = err.reason() }
