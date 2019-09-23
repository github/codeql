/**
 * @name Use of returnless function.
 * @description Using the return value of a function that does not return anything is highly suspicious.
 * @kind problem
 * @problem.severity recommendation
 * @id js/use-of-returnless-function
 * @tags maintainability,
 *       correctness
 * @precision high
 */

import javascript
import Declarations.UnusedVariable
import Expressions.ExprHasNoEffect

predicate returnsVoid(Function f) {
  exists(f.getBody().(Stmt)) and
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
  exists(ReturnStmt ret | 
    ret.getExpr() = e
  )
  or 
  exists(ConditionalExpr cond | cond.getABranch() = e and benignContext(cond)) 
  or 
  exists(BinaryExpr bin | (bin.getOperator() = "&&" or bin.getOperator() = "||") and bin.getAnOperand() = e and benignContext(bin)) 
  or
  exists(SeqExpr parent | parent.getAnOperand() = e and benignContext(parent))
  or
  exists(ParExpr par | par.getExpression() = e and benignContext(par))
  or
  
  // It is ok (or to be flagged by another query?) to await a non-async function. 
  exists(AwaitExpr await | await.getOperand() = e) 
  or
  
  // Avoid double reporting. It will always evaluate to false.
  exists(IfStmt ifStmt | ifStmt.getCondition() = e)
  or 
  // Avoid double reporting. `e` will always evaluate to undefined.
  exists(Comparison binOp | binOp.getAnOperand() = e)
  or
  // Avoid double reporting of "The base expression of this property access is always undefined.". 
  exists(PropAccess ac | ac.getBase() = e)
  or
  // The call is only in a non-void context because it is in a lambda.
  exists(ArrowFunctionExpr arrow |
    arrow.getBody() = e
  ) 
  or
  // Avoid double-reporting with unused local.
  exists(VariableDeclarator v | v.getInit() = e and v.getBindingPattern().getVariable() instanceof UnusedLocal)
}

from Function f, DataFlow::CallNode call
where
  // Intentionally only considering very precise callee information. It makes almost no difference.
  f = call.getACallee(0) and
  count(call.getACallee(0)) = 1 and 
  
  returnsVoid(f) and 
  
  // reflective calls don't have an ast-node, thus we can't decide whether or not they are in void-context.
  exists(call.asExpr()) and 
  
  not isStub(f) and 
  
  not call.getTopLevel().isMinified() and  
   
  not benignContext(call.asExpr()) and
  
  // anonymous one-shot closure. Those are used in weird ways and we ignore them.
  not call.getCalleeNode().asExpr() instanceof FunctionExpr and 

  // weeds out calls inside html-attributes.
  not(call.asExpr().getParent*() instanceof CodeInAttribute) and 
  // and JSX-attributes.
  not(call.asExpr().getParent*() instanceof JSXAttribute) and
  
  // Calls on "this" tend to overloaded. So future overloads might start returning something.
  not call.asExpr().(MethodCallExpr).getReceiver() instanceof ThisExpr and
  // similarly, methods received through parameters might later receive new dataflow. We have just only seen one callee.
  not call.getCalleeNode().getALocalSource() instanceof DataFlow::ParameterNode and
  
  // arguments to Promise.resolve (and promise library variants) are benign. 
  not exists(MethodCallExpr e | e.getCalleeName() = "resolve" and call.asExpr() = e.getArgument(0))
select
  call, "the function $@ does not return anything, yet the return value is used.", f, call.getCalleeName()
  