private import Raw

class ArrayLiteral extends @array_literal, Expr {
  override SourceLocation getLocation() { array_literal_location(this, result) }

  Expr getElement(int index) { array_literal_element(this, index, result) }

  Expr getAnElement() { array_literal_element(this, _, result) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = ArrayLiteralExpr(index) and
      result = this.getElement(index)
    )
  }
}
