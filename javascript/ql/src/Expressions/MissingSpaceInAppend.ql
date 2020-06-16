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

predicate isInConcat(Expr e) {
  exists(ParExpr par | isInConcat(par) and par.getExpression() = e)
  or
  exists(AddExpr a | a.getAnOperand() = e)
}

class ConcatenationLiteral extends Expr {
  ConcatenationLiteral() {
    (
      this instanceof TemplateLiteral
      or
      this instanceof Literal
    ) and
    isInConcat(this)
  }
}

Expr getConcatChild(Expr e) {
  result = rightChild(e) or
  result = leftChild(e)
}

Expr getConcatParent(Expr e) { e = getConcatChild(result) }

predicate isWordLike(ConcatenationLiteral lit) {
  lit.getStringValue().regexpMatch("(?i).*[a-z]{3,}.*")
}

class ConcatRoot extends AddExpr {
  ConcatRoot() { not isInConcat(this) }
}

ConcatRoot getAddRoot(AddExpr e) { result = getConcatParent*(e) }

predicate hasWordLikeFragment(AddExpr e) { isWordLike(getConcatChild*(getAddRoot(e))) }

from AddExpr e, ConcatenationLiteral l, ConcatenationLiteral r, string word
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
  not word.regexpMatch(".*[,\\.:].*[a-zA-Z].*[^a-zA-Z]") and
  // There must be a constant-string in the concatenation that looks like a word.
  hasWordLikeFragment(e)
select l, "This string appears to be missing a space after '" + word + "'."
