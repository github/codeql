/**
 * @name Detect And Handle Memory Allocation Errors
 * @description `operator new` throws an exception on allocation failures, while `operator new(std::nothrow)` returns a null pointer. Mixing up these two failure conditions can result in unexpected behavior.
 * @kind problem
 * @id cpp/detect-and-handle-memory-allocation-errors
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-570
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.controlflow.Guards

/**
 * A C++ `delete` or `delete[]` expression.
 */
class DeleteOrDeleteArrayExpr extends Expr {
  DeleteOrDeleteArrayExpr() { this instanceof DeleteExpr or this instanceof DeleteArrayExpr }

  DeallocationFunction getDeallocator() {
    result = [this.(DeleteExpr).getDeallocator(), this.(DeleteArrayExpr).getDeallocator()]
  }
}

/** Gets the `Constructor` invoked when `newExpr` allocates memory. */
Constructor getConstructorForAllocation(NewOrNewArrayExpr newExpr) {
  result.getACallToThisFunction().getLocation() = newExpr.getLocation()
}

/** Gets the `Destructor` invoked when `deleteExpr` deallocates memory. */
Destructor getDestructorForDeallocation(DeleteOrDeleteArrayExpr deleteExpr) {
  result.getACallToThisFunction().getLocation() = deleteExpr.getLocation()
}

/** Holds if the evaluation of `newExpr` may throw an exception. */
predicate newMayThrow(NewOrNewArrayExpr newExpr) {
  functionMayThrow(newExpr.getAllocator()) or
  functionMayThrow(getConstructorForAllocation(newExpr))
}

/** Holds if the evaluation of `deleteExpr` may throw an exception. */
predicate deleteMayThrow(DeleteOrDeleteArrayExpr deleteExpr) {
  functionMayThrow(deleteExpr.getDeallocator()) or
  functionMayThrow(getDestructorForDeallocation(deleteExpr))
}

/**
 * Holds if the function may throw an exception when called. That is, if the body of the function looks
 * like it might throw an exception, and the function does not have a `noexcept` or `throw()` specifier.
 */
predicate functionMayThrow(Function f) {
  (not exists(f.getBlock()) or stmtMayThrow(f.getBlock())) and
  not f.isNoExcept() and
  not f.isNoThrow()
}

/** Holds if the evaluation of `stmt` may throw an exception. */
predicate stmtMayThrow(Stmt stmt) {
  stmtMayThrow(stmt.(BlockStmt).getAStmt())
  or
  convertedExprMayThrow(stmt.(ExprStmt).getExpr())
  or
  exists(IfStmt ifStmt | ifStmt = stmt |
    convertedExprMayThrow(ifStmt.getCondition()) or
    stmtMayThrow([ifStmt.getThen(), ifStmt.getElse()])
  )
  or
  exists(Loop loop | loop = stmt |
    convertedExprMayThrow(loop.getCondition()) or
    stmtMayThrow(loop.getStmt())
  )
}

/** Holds if the evaluation of `e` (including conversions) may throw an exception. */
predicate convertedExprMayThrow(Expr e) { exprMayThrow(e.getFullyConverted()) }

/** Holds if the evaluation of `e` may throw an exception. */
predicate exprMayThrow(Expr e) {
  e instanceof DynamicCast
  or
  e instanceof TypeidOperator
  or
  e instanceof ThrowExpr
  or
  newMayThrow(e)
  or
  deleteMayThrow(e)
  or
  convertedExprMayThrow(e.(UnaryOperation).getOperand())
  or
  exists(BinaryOperation binOp | binOp = e |
    convertedExprMayThrow([binOp.getLeftOperand(), binOp.getRightOperand()])
  )
  or
  exists(CommaExpr comma | comma = e |
    convertedExprMayThrow([comma.getLeftOperand(), comma.getRightOperand()])
  )
  or
  exists(StmtExpr stmtExpr | stmtExpr = e |
    convertedExprMayThrow(stmtExpr.getResultExpr()) or
    stmtMayThrow(stmtExpr.getStmt())
  )
  or
  convertedExprMayThrow(e.(Conversion).getExpr())
  or
  exists(FunctionCall fc | fc = e |
    not exists(fc.getTarget()) or
    functionMayThrow(fc.getTarget()) or
    convertedExprMayThrow(fc.getAnArgument())
  )
}

/** An allocator that will not throw an exception. */
class NoThrowAllocator extends Function {
  NoThrowAllocator() {
    exists(NewOrNewArrayExpr newExpr |
      newExpr.getAllocator() = this and
      not functionMayThrow(this)
    )
  }
}

/** An allocator that might throw an exception. */
class ThrowingAllocator extends Function {
  ThrowingAllocator() { not this instanceof NoThrowAllocator }
}

/** The `std::bad_alloc` exception and its `bsl` variant. */
class BadAllocType extends Class {
  BadAllocType() { this.hasGlobalOrStdOrBslName("bad_alloc") }
}

/**
 * A catch block that catches a `std::bad_alloc` (or any of its subclasses), or a catch
 * block that catches every exception (i.e., `catch(...)`).
 */
class BadAllocCatchBlock extends CatchBlock {
  BadAllocCatchBlock() {
    this.getParameter().getUnspecifiedType() = any(BadAllocType badAlloc).getADerivedClass*()
    or
    not exists(this.getParameter())
  }
}

/**
 * Holds if `newExpr` will not throw an exception, but is embedded in a `try` statement
 * with a catch block `catchBlock` that catches an `std::bad_alloc` exception.
 */
predicate noThrowInTryBlock(NewOrNewArrayExpr newExpr, BadAllocCatchBlock catchBlock) {
  exists(TryStmt try |
    forall(Expr cand | cand.getEnclosingBlock().getEnclosingBlock*() = try.getStmt() |
      not convertedExprMayThrow(cand)
    ) and
    try.getACatchClause() = catchBlock and
    newExpr.getEnclosingBlock().getEnclosingBlock*() = try.getStmt() and
    not newMayThrow(newExpr)
  )
}

/**
 * Holds if `newExpr` is handles allocation failures by throwing an exception, yet
 * the guard condition `guard` compares the result of `newExpr` to a null value.
 */
predicate nullCheckInThrowingNew(NewOrNewArrayExpr newExpr, GuardCondition guard) {
  newExpr.getAllocator() instanceof ThrowingAllocator and
  (
    // Handles null comparisons.
    guard.ensuresEq(globalValueNumber(newExpr).getAnExpr(), any(NullValue null), _, _, _)
    or
    // Handles `if(ptr)` and `if(!ptr)` cases.
    guard = globalValueNumber(newExpr).getAnExpr()
  )
}

from NewOrNewArrayExpr newExpr, Element element, string msg, string elementString
where
  not newExpr.isFromUninstantiatedTemplate(_) and
  (
    noThrowInTryBlock(newExpr, element) and
    msg = "This allocation cannot throw. $@ is unnecessary." and
    elementString = "This catch block"
    or
    nullCheckInThrowingNew(newExpr, element) and
    msg = "This allocation cannot return null. $@ is unnecessary." and
    elementString = "This check"
  )
select newExpr, msg, element, elementString
