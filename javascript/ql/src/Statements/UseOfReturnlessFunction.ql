/**
 * @name Use of returnless function.
 * @description Using the return value of a function that does not explicitly return is indicative of a mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/use-of-returnless-function
 * @tags maintainability,
 *       correctness
 * @precision high
 */

import javascript
import Declarations.UnusedVariable
import Expressions.ExprHasNoEffect
import Statements.UselessConditional

predicate returnsVoid(Function f) {
  f.getBody() instanceof Stmt and
  not f instanceof ExternalDecl and
  not f.isGenerator() and
  not f.isAsync() and
  not exists(f.getAReturnedExpr())
}

predicate isStub(Function f) {
    f.getBodyStmt(0) instanceof ThrowStmt
    or
    f.getBody().(BlockStmt).getNumChild() = 0
}

predicate benignContext(Expr e) {
  inVoidContext(e) or 
  
  // A return statement is often used to just end the function.
  e = any(Function f).getAReturnedExpr()
  or 
  exists(ConditionalExpr cond | cond.getABranch() = e and benignContext(cond)) 
  or 
  exists(LogicalBinaryExpr bin | bin.getAnOperand() = e and benignContext(bin)) 
  or
  exists(SeqExpr seq, int i, int n | e = seq.getOperand(i) and n = seq.getNumOperands() |
    i < n - 1 or benignContext(seq)
exists(SeqExpr seq | seq.getLastOperand() = e and benignContext(seq))
  or
  exists(Expr parent | parent.getUnderlyingValue() = e and benignContext(parent))
  or 
  any(VoidExpr voidExpr).getOperand() = e

  or
  // weeds out calls inside HTML-attributes.
  e.getParent() instanceof CodeInAttribute or  
  // and JSX-attributes.
  e = any(JSXAttribute attr).getValue() or 
  
  // It is ok (or to be flagged by another query?) to await a non-async function. 
  exists(AwaitExpr await | await.getOperand() = e and benignContext(await)) 
  or
  // Avoid double reporting with js/trivial-conditional
  isExplicitConditional(_, e)
  or 
  // Avoid double reporting with js/comparison-between-incompatible-types
  any(Comparison binOp).getAnOperand() = e
  or
  // Avoid double reporting with js/property-access-on-non-object
  any(PropAccess ac).getBase() = e
  or
  // Avoid double-reporting with js/unused-local-variable
  exists(VariableDeclarator v | v.getInit() = e and v.getBindingPattern().getVariable() instanceof UnusedLocal)
  or
  // Avoid double reporting with js/call-to-non-callable
  any(InvokeExpr invoke).getCallee() = e
}

predicate functionBlacklist(Function f) {
  not returnsVoid(f)
  or 
  isStub(f)
}

predicate callBlacklist(DataFlow::CallNode call) {
  call.asExpr().getTopLevel().isMinified() or 
   
  benignContext(call.asExpr()) or 
  
  // anonymous one-shot closure. Those are used in weird ways and we ignore them.
  call.asExpr() = any(ImmediatelyInvokedFunctionExpr f).getInvocation() or  
  
  // arguments to Promise.resolve (and promise library variants) are benign. 
  call = any(ResolvedPromiseDefinition promise).getValue()
}

from DataFlow::CallNode call
where
  // Intentionally only considering very precise callee information. It makes almost no difference.
  not call.isIndefinite(_) and 
  forex(Function f | f = call.getACallee() | not functionBlacklist(f)) and
  
  exists(call.asExpr()) and // TODO: Need to figure out what to do about reflective calls.
  
  not callBlacklist(call)
select
  call, "the function $@ does not return anything, yet the return value is used.", call.getACallee(), call.getCalleeName()
  
