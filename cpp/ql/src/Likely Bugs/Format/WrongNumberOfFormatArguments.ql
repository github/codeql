/**
 * @name Too few arguments to formatting function
 * @description Calling a printf-like function with too few arguments can be
 *              a source of security issues.
 * @kind problem
 * @problem.severity error
 * @security-severity 5.0
 * @precision high
 * @id cpp/wrong-number-format-arguments
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-234
 *       external/cwe/cwe-685
 */

import cpp

class SyntaxError extends CompilerError {
  SyntaxError() { this.getTag().matches("exp_%") }

  predicate affects(Element e) {
    exists(Location l1, Location l2 |
      l1 = this.getLocation() and
      l2 = e.getLocation()
    |
      l1.getFile() = l2.getFile() and
      l1.getStartLine() = l2.getStartLine()
    )
  }
}

from FormatLiteral fl, FormattingFunctionCall ffc, int expected, int given, string ffcName
where
  ffc = fl.getUse() and
  expected = fl.getNumArgNeeded() and
  given = ffc.getNumFormatArgument() and
  expected > given and
  fl.specsAreKnown() and
  (
    if ffc.isInMacroExpansion()
    then ffcName = ffc.getTarget().getName() + " (in a macro expansion)"
    else ffcName = ffc.getTarget().getName()
  ) and
  // A typical problem is that string literals are concatenated, but if one of the string
  // literals is an undefined macro, then this just leads to a syntax error.
  not exists(SyntaxError e | e.affects(fl)) and
  not ffc.getArgument(_) instanceof ErrorExpr
select ffc,
  "Format for " + ffcName + " expects " + expected.toString() + " arguments but given " +
    given.toString()
