private import AstImport

class IndexExpr extends Expr, TIndexExpr {
  override string toString() { result = "...[...]" }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = indexExprIndex() and result = this.getIndex()
    or
    i = indexExprBase() and result = this.getBase()
  }

  Expr getIndex() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, indexExprIndex(), result)
      or
      not synthChild(r, indexExprIndex(), _) and
      result = getResultAst(r.(Raw::IndexExpr).getIndex())
    )
  }

  Expr getBase() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, indexExprBase(), result)
      or
      not synthChild(r, indexExprBase(), _) and
      result = getResultAst(r.(Raw::IndexExpr).getBase())
    )
  }

  predicate isNullConditional() { getRawAst(this).(Raw::IndexExpr).isNullConditional() }

  predicate isExplicitWrite(Ast assignment) {
    explicitAssignment(getRawAst(this), getRawAst(assignment))
  }

  predicate isImplicitWrite() {
    implicitAssignment(getRawAst(this))
  }
}

/** An `IndexExpr` that is being written to. */
class IndexExprWriteAccess extends IndexExpr {
  IndexExprWriteAccess() { this.isExplicitWrite(_) or this.isImplicitWrite() }
}

/** An `IndexExpr` that is being read from. */
class IndexExprReadAccess extends IndexExpr {
  IndexExprReadAccess() { not this instanceof IndexExprWriteAccess }
}
