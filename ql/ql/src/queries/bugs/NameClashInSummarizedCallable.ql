/**
 * @name Name clash in summarized callable
 * @description Two summarized callables with the same name may apply to each others' call sites
 * @kind problem
 * @problem.severity warning
 * @id ql/name-clash-in-summarized-callable
 * @tags correctness
 *       maintainability
 * @precision high
 */

import ql

/** A non-abstract subclass of `SummarizedCallable`. */
class SummarizedCallableImpl extends Class {
  SummarizedCallableImpl() {
    this.getType().getASuperType+().getName() = "SummarizedCallable" and
    not this.isAbstract()
  }

  /** Gets an expression bound to `this` in the charpred. */
  Expr getAThisBoundExpr() {
    exists(ThisAccess thisExpr |
      thisExpr.getEnclosingPredicate() = this.getCharPred() and
      any(ComparisonFormula eq | eq.getOperator() = "=").hasOperands(thisExpr, result)
    )
  }

  /** Gets a string value bound to `this` in the charpred. */
  string getAThisBoundString() { result = getStringValue(this.getAThisBoundExpr()) }

  /** Holds if this class appears to apply call site filtering. */
  predicate hasConditions() {
    exists(Conjunction expr | expr.getEnclosingPredicate() = this.getCharPred())
    or
    exists(this.getClassPredicate(["getACall", "getACallSimple"]))
  }
}

/** Holds if we should compute the string values of `e`. */
predicate needsStringValue(Expr e) {
  e = any(SummarizedCallableImpl impl).getAThisBoundExpr()
  or
  exists(Expr parent | needsStringValue(parent) |
    e = parent.(BinOpExpr).getAnOperand()
    or
    e = parent.(Set).getAnElement()
  )
}

/** Gets the string values of `e`. */
string getStringValue(Expr e) {
  needsStringValue(e) and
  (
    result = e.(String).getValue()
    or
    exists(BinOpExpr op |
      e = op and
      op.getOperator() = "+" and
      result = getStringValue(op.getLeftOperand()) + getStringValue(op.getRightOperand())
    )
    or
    result = getStringValue(e.(Set).getAnElement())
  )
}

/** Gets the enclosing `qlpack.yml` file in `folder` */
File getQLPackFromFolder(Folder folder) {
  result = folder.getFile("qlpack.yml")
  or
  not exists(folder.getFile("qlpack.yml")) and
  result = getQLPackFromFolder(folder.getParentContainer())
}

/** Gets a summarised callables in the given qlpack with the given this-value */
SummarizedCallableImpl getASummarizedCallableByNameAndPack(string name, File qlpack) {
  name = result.getAThisBoundString() and
  qlpack = getQLPackFromFolder(result.getFile().getParentContainer())
}

/** Holds if the given classes have a name clash. */
predicate hasClash(SummarizedCallableImpl class1, SummarizedCallableImpl class2, string name) {
  exists(File qlpack |
    class1 = getASummarizedCallableByNameAndPack(name, qlpack) and
    class2 = getASummarizedCallableByNameAndPack(name, qlpack) and
    class1 != class2 and
    class1.hasConditions()
  |
    // One of the classes is unconditional, implying that it disables the condition in the other
    not class2.hasConditions()
    or
    // Always report classes from different files, as it is considered too subtle of an interaction.
    class1.getFile() != class2.getFile()
  )
}

/** Like `hasClash` but tries to avoid duplicates. */
predicate hasClashBreakSymmetry(
  SummarizedCallableImpl class1, SummarizedCallableImpl class2, string name
) {
  hasClash(class1, class2, name) and
  hasClash(class2, class1, name) and
  // try to break symmetry arbitrarily
  class1.getName() <= class2.getName()
  or
  hasClash(class1, class2, name) and
  not hasClash(class2, class1, name)
}

from SummarizedCallableImpl class1, SummarizedCallableImpl class2, string name
where hasClashBreakSymmetry(class1, class2, name)
select class1,
  class1.getName() + " and $@ both bind 'this' to the string \"" + name +
    "\". They may accidentally apply to each others' call sites.", class2, class2.getName()
