/**
 * @name Whitespace contradicts operator precedence
 * @description Nested expressions where the formatting contradicts the grouping enforced by operator precedence
 *              are difficult to read and may even indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/whitespace-contradicts-precedence
 * @tags maintainability
 *       correctness
 *       statistical
 *       non-attributable
 *       external/cwe/cwe-783
 * @precision very-high
 */

import javascript

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
      parent instanceof Comparison and
      (this instanceof ArithmeticExpr or this instanceof ShiftExpr)
      or
      parent instanceof LogicalExpr and this instanceof Comparison
    )
  }
}

/**
 * Holds if contradicting whitespace for `binop` is unlikely to cause confusion.
 */
predicate benignWhitespace(BinaryExpr binop) {
  // asm.js like `expr |0` binary expression.
  not binop.getParent() instanceof BinaryExpr and
  binop.getOperator() = "|" and
  binop.getRightOperand().getIntValue() = 0
}

/**
 * Holds if `inner` is an operand of `outer`, and the relative precedence
 * may not be immediately clear, but is important for the semantics of
 * the expression (that is, the operators are not associative).
 */
predicate interestingNesting(BinaryExpr inner, BinaryExpr outer) {
  inner = outer.getAChildExpr() and
  not inner instanceof AssocNestedExpr and
  not inner instanceof HarmlessNestedExpr and
  not benignWhitespace(outer)
}

from BinaryExpr inner, BinaryExpr outer
where
  interestingNesting(inner, outer) and
  inner.getWhitespaceAroundOperator() > outer.getWhitespaceAroundOperator() and
  not outer.getTopLevel().isMinified()
select outer, "Whitespace around nested operators contradicts precedence."
