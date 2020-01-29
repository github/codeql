/**
 * @name Unnecessarily complex boolean expression
 * @description Boolean expressions that are unnecessarily complicated hinder readability.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/complex-boolean-expression
 * @tags readability
 */

import java

class BoolCompare extends EqualityTest {
  BoolCompare() { this.getAnOperand() instanceof BooleanLiteral }

  predicate simplify(string pattern, string rewrite) {
    exists(boolean b | b = this.getAnOperand().(BooleanLiteral).getBooleanValue() |
      this instanceof EQExpr and b = true and pattern = "A == true" and rewrite = "A"
      or
      this instanceof NEExpr and b = false and pattern = "A != false" and rewrite = "A"
      or
      this instanceof EQExpr and b = false and pattern = "A == false" and rewrite = "!A"
      or
      this instanceof NEExpr and b = true and pattern = "A != true" and rewrite = "!A"
    )
  }
}

predicate conditionalWithBool(ConditionalExpr c, string pattern, string rewrite) {
  exists(boolean truebranch |
    c.getTrueExpr().(BooleanLiteral).getBooleanValue() = truebranch and
    not c.getFalseExpr() instanceof BooleanLiteral and
    not c.getFalseExpr().getType() instanceof NullType and
    (
      truebranch = true and pattern = "A ? true : B" and rewrite = "A || B"
      or
      truebranch = false and pattern = "A ? false : B" and rewrite = "!A && B"
    )
  )
  or
  exists(boolean falsebranch |
    not c.getTrueExpr() instanceof BooleanLiteral and
    not c.getTrueExpr().getType() instanceof NullType and
    c.getFalseExpr().(BooleanLiteral).getBooleanValue() = falsebranch and
    (
      falsebranch = true and pattern = "A ? B : true" and rewrite = "!A || B"
      or
      falsebranch = false and pattern = "A ? B : false" and rewrite = "A && B"
    )
  )
  or
  exists(boolean truebranch, boolean falsebranch |
    c.getTrueExpr().(BooleanLiteral).getBooleanValue() = truebranch and
    c.getFalseExpr().(BooleanLiteral).getBooleanValue() = falsebranch and
    (
      truebranch = true and falsebranch = false and pattern = "A ? true : false" and rewrite = "A"
      or
      truebranch = false and falsebranch = true and pattern = "A ? false : true" and rewrite = "!A"
    )
  )
}

class ComparisonOrEquality extends BinaryExpr {
  ComparisonOrEquality() { this instanceof ComparisonExpr or this instanceof EqualityTest }

  predicate negate(string pattern, string rewrite) {
    this instanceof EQExpr and pattern = "!(A == B)" and rewrite = "A != B"
    or
    this instanceof NEExpr and pattern = "!(A != B)" and rewrite = "A == B"
    or
    this instanceof LTExpr and pattern = "!(A < B)" and rewrite = "A >= B"
    or
    this instanceof GTExpr and pattern = "!(A > B)" and rewrite = "A <= B"
    or
    this instanceof LEExpr and pattern = "!(A <= B)" and rewrite = "A > B"
    or
    this instanceof GEExpr and pattern = "!(A >= B)" and rewrite = "A < B"
  }
}

from Expr e, string pattern, string rewrite
where
  e.(BoolCompare).simplify(pattern, rewrite)
  or
  conditionalWithBool(e, pattern, rewrite)
  or
  e.(LogNotExpr).getExpr().(ComparisonOrEquality).negate(pattern, rewrite)
  or
  e.(LogNotExpr).getExpr() instanceof LogNotExpr and
  pattern = "!!A" and
  rewrite = "A"
select e, "Expressions of the form \"" + pattern + "\" can be simplified to \"" + rewrite + "\"."
