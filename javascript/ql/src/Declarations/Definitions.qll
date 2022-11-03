import javascript

/** An identifier appearing in a defining position. */
class DefiningIdentifier extends Identifier {
  DefiningIdentifier() {
    this instanceof VarDecl or
    exists(Assignment assgn | this = assgn.getLhs()) or
    exists(UpdateExpr upd | this = upd.getOperand())
  }
}
