/**
 * @name Whitespace contradicts operator precedence
 * @description Nested expressions where the formatting contradicts the grouping enforced by operator precedence
 *              are difficult to read and may even indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id go/whitespace-contradicts-precedence
 * @tags maintainability
 *       correctness
 *       external/cwe/cwe-783
 * @precision very-high
 */

import go

/**
 * A nested associative expression.
 *
 * That is, a binary expression of the form `x op y`, which is itself an operand
 * (say, the left) of another binary expression `(x op y) op' z` such that
 * `(x op y) op' z = x op (y op' z)`, disregarding overflow.
 */
class AssocNestedExpr extends BinaryExpr {
  AssocNestedExpr() {
    exists(BinaryExpr parent, int idx | this = parent.getChildExpr(idx) |
      // +, *, &&, || and the bitwise operations are associative
      (
        this instanceof AddExpr or
        this instanceof MulExpr or
        this instanceof BitwiseExpr or
        this instanceof LogicalBinaryExpr
      ) and
      parent.getOperator() = this.getOperator()
      or
      // (x*y)/z = x*(y/z)
      this instanceof MulExpr and parent instanceof DivExpr and idx = 0
      or
      // (x/y)%z = x/(y%z)
      this instanceof DivExpr and parent instanceof ModExpr and idx = 0
      or
      // (x+y)-z = x+(y-z)
      this instanceof AddExpr and parent instanceof SubExpr and idx = 0
    )
  }
}

/**
 * A binary expression nested inside another binary expression where the relative
 * precedence of the two operators is unlikely to cause confusion.
 */
class HarmlessNestedExpr extends BinaryExpr {
  HarmlessNestedExpr() {
    exists(BinaryExpr parent | this = parent.getAChildExpr() |
      parent instanceof ComparisonExpr and
      (this instanceof ArithmeticExpr or this instanceof ShiftExpr)
      or
      parent instanceof LogicalExpr and this instanceof ComparisonExpr
    )
  }
}

/**
 * Holds if `inner` is an operand of `outer`, and the relative precedence
 * may not be immediately clear, but is important for the semantics of
 * the expression (that is, the operators are not associative).
 */
predicate interestingNesting(BinaryExpr inner, BinaryExpr outer) {
  inner = outer.getAChildExpr() and
  not inner instanceof AssocNestedExpr and
  not inner instanceof HarmlessNestedExpr
}

/** Gets the number of whitespace characters around the operator `op` of `be`. */
int getWhitespaceAroundOperator(BinaryExpr be, string op) {
  exists(string file, int line, int left, int right |
    be.getLeftOperand().hasLocationInfo(file, _, _, line, left) and
    be.getRightOperand().hasLocationInfo(file, line, right, _, _) and
    op = be.getOperator() and
    result = (right - left - op.length() - 1) / 2
  )
}

from BinaryExpr inner, BinaryExpr outer, string innerOp, string outerOp
where
  interestingNesting(inner, outer) and
  getWhitespaceAroundOperator(inner, innerOp) > getWhitespaceAroundOperator(outer, outerOp)
select outer,
  innerOp + " is evaluated before " + outerOp + ", but whitespace suggests the opposite."
