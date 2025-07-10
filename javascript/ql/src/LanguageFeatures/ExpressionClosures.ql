/**
 * @name Use of platform-specific language features
 * @description Non-standard language features such as expression closures or let expressions
 *              make it harder to reuse code.
 * @kind problem
 * @problem.severity warning
 * @id js/non-standard-language-feature
 * @tags portability
 *       maintainability
 *       language-features
 *       external/cwe/cwe-758
 * @precision very-high
 */

import javascript

/**
 * Holds if `nd` is a use of deprecated language feature `type`, and `replacement`
 * is the recommended replacement.
 */
predicate deprecated_feature(AstNode nd, string type, string replacement) {
  exists(FunctionExpr fe | fe = nd and fe.getBody() instanceof Expr |
    type = "expression closures" and replacement = "arrow expressions"
  )
  or
  nd instanceof LegacyLetExpr and type = "let expressions" and replacement = "let declarations"
  or
  nd instanceof LegacyLetStmt and type = "let statements" and replacement = "let declarations"
  or
  nd instanceof ForEachStmt and type = "for each statements" and replacement = "for of statements"
  or
  nd.(ComprehensionExpr).isPostfix() and
  type = "postfix comprehensions" and
  replacement = "prefix comprehensions"
  or
  nd.(ExprStmt).isDoubleColonMethod(_, _, _) and
  type = "double colon method declarations" and
  replacement = "standard method definitions"
}

from AstNode depr, string type, string replacement
where deprecated_feature(depr, type, replacement)
select depr, "Use " + replacement + " instead of " + type + "."
