/**
 * @name Misleading indentation of dangling 'else'
 * @description The 'else' clause of an 'if' statement should be aligned with the 'if' it belongs to.
 * @kind problem
 * @problem.severity warning
 * @id js/misleading-indentation-of-dangling-else
 * @tags readability
 *       statistical
 *       non-attributable
 *       external/cwe/cwe-483
 * @precision very-high
 */

import javascript

/**
 * A token that is relevant for this query, that is, an `if`, `else` or `}` token.
 */
class RelevantToken extends Token {
  RelevantToken() { exists(string v | v = getValue() | v = "if" or v = "else" or v = "}") }
}

/**
 * Holds if `prev` precedes `tk` on the same line, where `val` is the value of `tk`
 * and `prevVal` is the value of `prev`.
 */
predicate prevTokenOnSameLine(RelevantToken tk, string val, Token prev, string prevVal) {
  val = tk.getValue() and
  prev = tk.getPreviousToken() and
  prev.getLocation().getEndLine() = tk.getLocation().getStartLine() and
  prevVal = prev.getValue()
}

/**
 * Gets the semantic indentation of token `tk`.
 *
 * The semantic indentation of a token `tk` is defined as follows:
 *
 *   1. If `tk` is the first token on its line, its semantic indentation is its start column.
 *   2. Otherwise, if `tk` is an `if` token preceded by an `else` token, or an `else` token
 *      preceded by an `}` token, its semantic indentation is the semantic indentation of that
 *      preceding token.
 *   3. Otherwise, the token has no semantic indentation.
 *
 * The intuitive idea is that the `if` token of an `else if` branch is assigned the indentation
 * of the preceding `else` token, or even that of the `}` token preceding the `else`, but only
 * if these tokens are on the same line as the `if`.
 */
int semanticIndent(RelevantToken tk) {
  not prevTokenOnSameLine(tk, _, _, _) and
  result = tk.getLocation().getStartColumn()
  or
  exists(RelevantToken prev |
    prevTokenOnSameLine(tk, "if", prev, "else") or
    prevTokenOnSameLine(tk, "else", prev, "}")
  |
    result = semanticIndent(prev)
  )
}

/**
 * Gets the semantic indentation of the `if` token of statement `i`.
 */
int ifIndent(IfStmt i) { result = semanticIndent(i.getIfToken()) }

/**
 * Gets the semantic indentation of the `else` token of statement `i`,
 * if any.
 */
int elseIndent(IfStmt i) { result = semanticIndent(i.getElseToken()) }

from IfStmt outer, IfStmt inner, Token outerIf, Token innerIf, Token innerElse, int outerIndent
where
  inner = outer.getThen().getAChildStmt*() and
  outerIf = outer.getIfToken() and
  outerIndent = ifIndent(outer) and
  innerIf = inner.getIfToken() and
  innerElse = inner.getElseToken() and
  outerIndent < ifIndent(inner) and
  outerIndent = elseIndent(inner) and
  not outer.getTopLevel().isMinified()
select innerElse, "This else branch belongs to $@, but its indentation suggests it belongs to $@.",
  innerIf, "this if statement", outerIf, "this other if statement"
