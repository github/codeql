/**
 * @name Logical expression could be simplified
 * @description When a logical expression can be easily simplified, there may
 *              be an opportunity to improve readability by doing so, or it may
 *              indicate that the code contains a typo.
 * @kind problem
 * @id cpp/logical-expr-could-be-simplified
 * @problem.severity warning
 * @tags maintainability
 */

import cpp

/**
 * A simple literal (i.e. not a macro expansion, enum constant
 * or template argument).
 */
predicate simple(Literal l) {
  l instanceof OctalLiteral or
  l instanceof HexLiteral or
  l instanceof CharLiteral or
  l.getValueText() = "true" or
  l.getValueText() = "false" or
  // Parsing doubles is too slow...
  //exists(l.getValueText().toFloat())
  // Instead, check whether the literal starts with a letter.
  not l.getValueText().regexpMatch("[a-zA-Z_].*")
}

predicate booleanLiteral(Literal l) {
  simple(l) and
  (l.getValue() = "0" or l.getValue() = "1" or l.getValue() = "true" or l.getValue() = "false")
}

string boolLiteralInLogicalOp(Literal literal) {
  booleanLiteral(literal) and
  literal.getParent() instanceof BinaryLogicalOperation and
  result =
    "Literal value " + literal.getValueText() +
      " is used in a logical expression; simplify or use a constant."
}

string comparisonOnLiterals(ComparisonOperation op) {
  simple(op.getLeftOperand()) and
  simple(op.getRightOperand()) and
  not op.getAnOperand().isInMacroExpansion() and
  if exists(op.getValue())
  then result = "This comparison involves two literals and is always " + op.getValue() + "."
  else result = "This comparison involves two literals and should be simplified."
}

from Expr e, string msg
where
  (msg = boolLiteralInLogicalOp(e) or msg = comparisonOnLiterals(e)) and
  not e.isInMacroExpansion()
select e, msg
