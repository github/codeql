/**
 * @name Missing space in string concatenation
 * @description Joining constant strings into a longer string where
 *              two words are concatenated without a separating space
 *              usually indicates a text error.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/missing-space-in-concatenation
 * @tags readability
 */

import javascript

Expr rightChild(Expr e) {
  result = e.(ParExpr).getExpression() or
  result = e.(AddExpr).getRightOperand()
}

Expr leftChild(Expr e) {
  result = e.(ParExpr).getExpression() or
  result = e.(AddExpr).getLeftOperand()
}

class LiteralOrTemplate extends Expr {
  LiteralOrTemplate() {
    this instanceof TemplateLiteral or
    this instanceof Literal
  }
}

from AddExpr e, LiteralOrTemplate l, LiteralOrTemplate r, string word
where
  // l and r are appended together
  l = rightChild*(e.getLeftOperand()) and
  r = leftChild*(e.getRightOperand()) and
  // `l + r` is of the form `... word" + "word2...`, possibly including some
  // punctuation after `word`.
  // Only the first character of `word2` is matched, whereas `word` is matched
  // completely to distinguish grammatical punctuation after which a space is
  // needed, and intra-identifier punctuation in, for example, a qualified name.
  word = l.getStringValue().regexpCapture(".* (([-A-Za-z/'\\.:,]*[a-zA-Z]|[0-9]+)[\\.:,!?']*)", 1) and
  r.getStringValue().regexpMatch("[a-zA-Z].*") and
  not word.regexpMatch(".*[,\\.:].*[a-zA-Z].*[^a-zA-Z]")
select l, "This string appears to be missing a space after '" + word + "'."
