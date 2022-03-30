/**
 * @name Use of octal values
 * @description An integer literal that starts with '0' may cause a problem. If the '0' is
 *              intentional, a programmer may misread the literal as a decimal literal. If the '0'
 *              is unintentional and a decimal literal is intended, the compiler treats the
 *              literal as an octal literal.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/octal-literal
 * @tags maintainability
 *       correctness
 */

import java

from IntegerLiteral lit, string val
where
  lit.getLiteral() = val and
  val.regexpMatch("0[0-7][0-7]+") and
  lit.getParent() instanceof BinaryExpr and
  not lit.getParent() instanceof BitwiseExpr and
  not lit.getParent() instanceof ComparisonExpr
select lit, "Integer literal starts with 0."
