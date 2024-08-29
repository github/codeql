import powershell

class ArrayLiteral extends @array_literal, Expr {
  override SourceLocation getLocation() { array_literal_location(this, result) }

  Expr getElement(int index) { array_literal_element(this, index, result) }

  Expr getAnElement() { array_literal_element(this, _, result) }

  override string toString() { result = "...,..." }
}
