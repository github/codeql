import cpp

// an expression of the form sizeof(e) or strlen(e)
class BufferSizeExpr extends Expr {
  BufferSizeExpr() {
    this instanceof SizeofExprOperator or
    this instanceof StrlenCall
  }

  Expr getArg() {
    result = this.(SizeofExprOperator).getExprOperand() or
    result = this.(StrlenCall).getStringExpr()
  }
}
