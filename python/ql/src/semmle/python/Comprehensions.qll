import python

/** Base class for list, set and dictionary comprehensions, and generator expressions. */
abstract class Comp extends Expr {
  abstract Function getFunction();

  /** Gets the iterable of this set comprehension. */
  abstract Expr getIterable();

  /** Gets the iteration variable for the nth innermost generator of this comprehension. */
  Variable getIterationVariable(int n) {
    result.getAnAccess() = this.getNthInnerLoop(n).getTarget()
  }

  /** Gets the nth innermost For expression of this comprehension. */
  For getNthInnerLoop(int n) {
    n = 0 and result = this.getFunction().getStmt(0)
    or
    result = this.getNthInnerLoop(n - 1).getStmt(0)
  }

  /** Gets the iteration variable for a generator of this list comprehension. */
  Variable getAnIterationVariable() { result = this.getIterationVariable(_) }

  /** Gets the scope in which the body of this list comprehension evaluates. */
  Scope getEvaluatingScope() { result = this.getFunction() }

  /** Gets the expression for elements of this comprehension. */
  Expr getElt() {
    exists(Yield yield, Stmt body |
      result = yield.getValue() and
      body = this.getNthInnerLoop(_).getAStmt()
    |
      yield = body.(ExprStmt).getValue()
      or
      yield = body.(If).getStmt(0).(ExprStmt).getValue()
    )
  }
}

/** A list comprehension, such as `[ chr(x) for x in range(ord('A'), ord('Z')+1) ]` */
class ListComp extends ListComp_, Comp {
  override Expr getASubExpression() {
    result = this.getAGenerator().getASubExpression() or
    result = this.getElt() or
    result = this.getIterable()
  }

  override AstNode getAChildNode() {
    result = this.getAGenerator() or
    result = this.getIterable() or
    result = this.getFunction()
  }

  override predicate hasSideEffects() { any() }

  /** Gets the scope in which the body of this list comprehension evaluates. */
  override Scope getEvaluatingScope() {
    major_version() = 2 and result = this.getScope()
    or
    major_version() = 3 and result = this.getFunction()
  }

  /** Gets the iteration variable for the nth innermost generator of this list comprehension */
  override Variable getIterationVariable(int n) { result = Comp.super.getIterationVariable(n) }

  override Function getFunction() { result = ListComp_.super.getFunction() }

  override Expr getIterable() { result = ListComp_.super.getIterable() }

  override string toString() { result = ListComp_.super.toString() }

  override Expr getElt() { result = Comp.super.getElt() }
}

/** A set comprehension such as  `{ v for v in "0123456789" }` */
class SetComp extends SetComp_, Comp {
  override Expr getASubExpression() { result = this.getIterable() }

  override AstNode getAChildNode() {
    result = this.getASubExpression() or
    result = this.getFunction()
  }

  override predicate hasSideEffects() { any() }

  override Function getFunction() { result = SetComp_.super.getFunction() }

  override Expr getIterable() { result = SetComp_.super.getIterable() }
}

/** A dictionary comprehension, such as `{ k:v for k, v in enumerate("0123456789") }` */
class DictComp extends DictComp_, Comp {
  override Expr getASubExpression() { result = this.getIterable() }

  override AstNode getAChildNode() {
    result = this.getASubExpression() or
    result = this.getFunction()
  }

  override predicate hasSideEffects() { any() }

  override Function getFunction() { result = DictComp_.super.getFunction() }

  override Expr getIterable() { result = DictComp_.super.getIterable() }
}

/** A generator expression, such as `(var for var in iterable)` */
class GeneratorExp extends GeneratorExp_, Comp {
  override Expr getASubExpression() { result = this.getIterable() }

  override AstNode getAChildNode() {
    result = this.getASubExpression() or
    result = this.getFunction()
  }

  override predicate hasSideEffects() { any() }

  override Function getFunction() { result = GeneratorExp_.super.getFunction() }

  override Expr getIterable() { result = GeneratorExp_.super.getIterable() }
}
