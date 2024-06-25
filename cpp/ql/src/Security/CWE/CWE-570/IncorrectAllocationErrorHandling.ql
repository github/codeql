/**
 * @name Incorrect allocation-error handling
 * @description Mixing up the failure conditions of 'operator new' and 'operator new(std::nothrow)' can result in unexpected behavior.
 * @kind problem
 * @id cpp/incorrect-allocation-error-handling
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-570
 *       external/cwe/cwe-252
 *       external/cwe/cwe-755
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.controlflow.Guards

/** Gets the `Constructor` invoked when `newExpr` allocates memory. */
Constructor getConstructorForAllocation(NewOrNewArrayExpr newExpr) {
  result.getACallToThisFunction() = newExpr.getInitializer()
}

/** Gets the `Destructor` invoked when `deleteExpr` deallocates memory. */
Destructor getDestructorForDeallocation(DeleteOrDeleteArrayExpr deleteExpr) {
  result = deleteExpr.getDestructor()
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
  convertedExprMayThrow(stmt.(DeclStmt).getADeclaration().(Variable).getInitializer().getExpr())
  or
  exists(IfStmt ifStmt | ifStmt = stmt |
    convertedExprMayThrow(ifStmt.getCondition()) or
    stmtMayThrow([ifStmt.getThen(), ifStmt.getElse()])
  )
  or
  exists(ConstexprIfStmt constIfStmt | constIfStmt = stmt |
    stmtMayThrow([constIfStmt.getThen(), constIfStmt.getElse()])
  )
  or
  exists(Loop loop | loop = stmt |
    convertedExprMayThrow(loop.getCondition()) or
    stmtMayThrow(loop.getStmt())
  )
  or
  // The case for `Loop` already checked the condition and the statement.
  convertedExprMayThrow(stmt.(RangeBasedForStmt).getUpdate())
  or
  // The case for `Loop` already checked the condition and the statement.
  exists(ForStmt forStmt | forStmt = stmt |
    stmtMayThrow(forStmt.getInitialization())
    or
    convertedExprMayThrow(forStmt.getUpdate())
  )
  or
  exists(SwitchStmt switchStmt | switchStmt = stmt |
    convertedExprMayThrow(switchStmt.getExpr()) or
    stmtMayThrow(switchStmt.getStmt())
  )
  or
  // NOTE: We don't include `TryStmt` as those exceptions are not "observable" outside the function.
  stmtMayThrow(stmt.(Handler).getBlock())
  or
  convertedExprMayThrow(stmt.(CoReturnStmt).getExpr())
  or
  convertedExprMayThrow(stmt.(ReturnStmt).getExpr())
}

/** Holds if the evaluation of `e` (including conversions) may throw an exception. */
predicate convertedExprMayThrow(Expr e) {
  exprMayThrow(e)
  or
  convertedExprMayThrow(e.getConversion())
}

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
  exists(Assignment assign | assign = e |
    convertedExprMayThrow([assign.getLValue(), assign.getRValue()])
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

/** The `std::nothrow_t` class and its `bsl` variant. */
class NoThrowType extends Struct {
  NoThrowType() { this.hasGlobalOrStdOrBslName("nothrow_t") }
}

/** An allocator that might throw an exception. */
class ThrowingAllocator extends Function {
  ThrowingAllocator() {
    exists(NewOrNewArrayExpr newExpr |
      newExpr.getAllocator() = this and
      // Exclude custom overloads of `operator new`.
      // What we really want here is to only include the functions that satisfy `functionMayThrow`, but
      // there seems to be examples where `throw()` isn't extracted (which causes false positives).
      //
      // As noted in the QLDoc for `Function.getAllocatorCall`:
      //
      // "As a rule of thumb, there will be an allocator call precisely when the type
      // being allocated has a custom `operator new`, or when an argument list appears
      // after the `new` keyword and before the name of the type being allocated.
      //
      // In particular note that uses of placement-new and nothrow-new will have an
      // allocator call."
      //
      // So we say an allocator might throw if:
      // 1. It doesn't have a body
      // 2. there isn't a parameter with type `nothrow_t`
      // 3. the allocator isn't marked with `throw()` or `noexcept`.
      not exists(this.getBlock()) and
      not exists(Parameter p | p = this.getAParameter() |
        p.getUnspecifiedType().stripType() instanceof NoThrowType
      ) and
      not this.isNoExcept() and
      not this.isNoThrow()
    )
  }
}

/** The `std::bad_alloc` exception and its `bsl` variant. */
class BadAllocType extends Class {
  BadAllocType() { this.hasGlobalOrStdOrBslName("bad_alloc") }
}

/**
 * A catch block that catches a `std::bad_alloc` (or any of its superclasses), or a catch
 * block that catches every exception (i.e., `catch(...)`).
 */
class BadAllocCatchBlock extends CatchBlock {
  BadAllocCatchBlock() {
    this.getParameter().getUnspecifiedType().stripType() =
      any(BadAllocType badAlloc).getABaseClass*()
    or
    not exists(this.getParameter())
  }
}

/**
 * Holds if `newExpr` is embedded in a `try` statement with a catch block `catchBlock` that
 * catches a `std::bad_alloc` exception, but nothing in the `try` block (including the `newExpr`)
 * will throw that exception.
 */
predicate noThrowInTryBlock(NewOrNewArrayExpr newExpr, BadAllocCatchBlock catchBlock) {
  exists(TryStmt try |
    not stmtMayThrow(try.getStmt()) and
    try.getACatchClause() = catchBlock and
    newExpr.getEnclosingBlock().getEnclosingBlock*() = try.getStmt()
  )
}

/**
 * Holds if `newExpr` is handles allocation failures by throwing an exception, yet
 * the guard condition `guard` compares the result of `newExpr` to a null value.
 */
predicate nullCheckInThrowingNew(NewOrNewArrayExpr newExpr, GuardCondition guard) {
  newExpr.getAllocator() instanceof ThrowingAllocator and
  // There can be many guard conditions that compares `newExpr` againgst 0.
  // For example, for `if(!p)` both `p` and `!p` are guard conditions. To not
  // produce duplicates results we pick the "first" guard condition according
  // to some arbitrary ordering (i.e., location information). This means `!p` is the
  // element that we use to construct the alert.
  guard =
    min(GuardCondition gc, int startline, int startcolumn, int endline, int endcolumn |
      gc.comparesEq(globalValueNumber(newExpr).getAnExpr(), 0, _, _) and
      gc.getLocation().hasLocationInfo(_, startline, startcolumn, endline, endcolumn)
    |
      gc order by startline, startcolumn, endline, endcolumn
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
