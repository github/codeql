private import Raw

class Redirection extends @redirection, Ast {
  Expr getExpr() { parent(result, this) } // TODO: Is there really no other way to get this?

  final override Ast getChild(ChildIndex i) {
    i = RedirectionExpr() and
    result = this.getExpr()
  }
}
