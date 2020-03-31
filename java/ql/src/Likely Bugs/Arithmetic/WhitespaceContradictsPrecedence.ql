/**
 * @name Whitespace contradicts operator precedence
 * @description Nested expressions where the formatting contradicts the grouping enforced by operator precedence
 *              are difficult to read and may even indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/whitespace-contradicts-precedence
 * @tags maintainability
 *       readability
 *       external/cwe/cwe-783
 */

import java

/**
 * A binary expression using the operator
 * `+`, `-`, `*`, `/`, or `%`.
 */
class ArithmeticExpr extends BinaryExpr {
  ArithmeticExpr() {
    this instanceof AddExpr or
    this instanceof SubExpr or
    this instanceof MulExpr or
    this instanceof DivExpr or
    this instanceof RemExpr
  }
}

/**
 * A binary expression using the operator
 * `<<`, `>>`, or `>>>`.
 */
class ShiftExpr extends BinaryExpr {
  ShiftExpr() {
    this instanceof LShiftExpr or
    this instanceof RShiftExpr or
    this instanceof URShiftExpr
  }
}

/**
 * A binary expression using the operator
 * `==`, `!=`, `<`, `>`, `<=`, or `>=`.
 */
class RelationExpr extends BinaryExpr {
  RelationExpr() {
    this instanceof EqualityTest or
    this instanceof ComparisonExpr
  }
}

/**
 * A binary expression using the operator
 * `&&` or `||`.
 */
class LogicalExpr extends BinaryExpr {
  LogicalExpr() {
    this instanceof AndLogicalExpr or
    this instanceof OrLogicalExpr
  }
}

/**
 * A binary expression of the form `x op y`, which is itself an operand (say, the left) of
 * another binary expression `(x op y) op' y` such that `(x op y) op' y' = x op (y op' y)`,
 * disregarding overflow.
 */
class AssocNestedExpr extends BinaryExpr {
  AssocNestedExpr() {
    exists(BinaryExpr parent, int idx | this.isNthChildOf(parent, idx) |
      // `+`, `*`, `&&`, `||` and the bitwise operations are associative.
      (
        this instanceof AddExpr or
        this instanceof MulExpr or
        this instanceof BitwiseExpr or
        this instanceof LogicalExpr
      ) and
      parent.getKind() = this.getKind()
      or
      // Equality tests are associate over each other.
      this instanceof EqualityTest and parent instanceof EqualityTest
      or
      // (x*y)/z = x*(y/z)
      this instanceof MulExpr and parent instanceof DivExpr and idx = 0
      or
      // (x/y)%z = x/(y%z)
      this instanceof DivExpr and parent instanceof RemExpr and idx = 0
      or
      // (x+y)-z = x+(y-z)
      this instanceof AddExpr and parent instanceof SubExpr and idx = 0
    )
  }
}

/**
 * A binary expression nested inside another binary expression where the inner operator "obviously"
 * binds tighter than the outer one. This is obviously subjective.
 */
class HarmlessNestedExpr extends BinaryExpr {
  HarmlessNestedExpr() {
    exists(BinaryExpr parent | this = parent.getAChildExpr() |
      parent instanceof RelationExpr and
      (this instanceof ArithmeticExpr or this instanceof ShiftExpr)
      or
      parent instanceof LogicalExpr and this instanceof RelationExpr
    )
  }
}

predicate startOfBinaryRhs(BinaryExpr expr, int line, int col) {
  exists(Location rloc | rloc = expr.getRightOperand().getLocation() |
    rloc.getStartLine() = line and rloc.getStartColumn() = col
  )
}

predicate endOfBinaryLhs(BinaryExpr expr, int line, int col) {
  exists(Location lloc | lloc = expr.getLeftOperand().getLocation() |
    lloc.getEndLine() = line and lloc.getEndColumn() = col
  )
}

/** Compute the number of parenthesis characters next to the operator. */
int getParensNextToOp(BinaryExpr expr) {
  exists(Expr left, Expr right, int pleft, int pright |
    left = expr.getLeftOperand() and
    right = expr.getRightOperand() and
    (if left.isParenthesized() then isParenthesized(left, pleft) else pleft = 0) and
    (if right.isParenthesized() then isParenthesized(right, pright) else pright = 0) and
    result = pleft + pright
  )
}

/** Compute whitespace around the operator. */
int operatorWS(BinaryExpr expr) {
  exists(int line, int lcol, int rcol, int parens |
    endOfBinaryLhs(expr, line, lcol) and
    startOfBinaryRhs(expr, line, rcol) and
    parens = getParensNextToOp(expr) and
    result = rcol - lcol + 1 - expr.getOp().length() - parens
  )
}

/** Find nested binary expressions where the programmer may have made a precedence mistake. */
predicate interestingNesting(BinaryExpr inner, BinaryExpr outer) {
  inner = outer.getAChildExpr() and
  not inner instanceof AssocNestedExpr and
  not inner instanceof HarmlessNestedExpr and
  not inner.isParenthesized()
}

from BinaryExpr inner, BinaryExpr outer, int wsouter, int wsinner
where
  interestingNesting(inner, outer) and
  wsinner = operatorWS(inner) and
  wsouter = operatorWS(outer) and
  wsinner % 2 = 0 and
  wsouter % 2 = 0 and
  wsinner > wsouter
select outer, "Whitespace around nested operators contradicts precedence."
