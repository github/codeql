/**
 * @name Use of returnless function
 * @description Using the return value of a function that does not return an expression is indicative of a mistake.
 * @kind problem
 * @problem.severity warning
 * @id js/use-of-returnless-function
 * @tags maintainability
 *       correctness
 * @precision high
 */

import javascript
import Declarations.UnusedVariable
import Expressions.ExprHasNoEffect
import Statements.UselessConditional

predicate returnsVoid(Function f) {
  not f.isGenerator() and
  not f.isAsync() and
  not exists(f.getAReturnedExpr())
}

predicate isStub(Function f) {
  f.getBody().(BlockStmt).getNumChild() = 0
  or
  f instanceof ExternalDecl
}

/**
 * Holds if `e` is in a syntactic context where it likely is fine that the value of `e` comes from a call to a returnless function.
 */
predicate benignContext(Expr e) {
  inVoidContext(e)
  or
  // A return statement is often used to just end the function.
  e = any(Function f).getBody()
  or
  e = any(ReturnStmt r).getExpr()
  or
  exists(ConditionalExpr cond | cond.getABranch() = e and benignContext(cond))
  or
  exists(LogicalBinaryExpr bin | bin.getAnOperand() = e and benignContext(bin))
  or
  exists(Expr parent | parent.getUnderlyingValue() = e and benignContext(parent))
  or
  any(VoidExpr voidExpr).getOperand() = e
  or
  // weeds out calls inside HTML-attributes.
  e.getParent().(ExprStmt).getParent() instanceof CodeInAttribute
  or
  // and JSX-attributes.
  e = any(JsxAttribute attr).getValue()
  or
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
  exists(VariableDeclarator v |
    v.getInit() = e and v.getBindingPattern().getVariable() instanceof UnusedLocal
  )
  or
  // Avoid double reporting with js/call-to-non-callable
  any(InvokeExpr invoke).getCallee() = e
  or
  // arguments to Promise.resolve (and promise library variants) are benign.
  e = any(PromiseCreationCall promise).getValue().asExpr()
  or
  // arguments to other (unknown) promise creations.
  e = any(DataFlow::CallNode call | call.getCalleeName() = "resolve").getAnArgument().asExpr()
}

predicate oneshotClosure(DataFlow::CallNode call) {
  call.getCalleeNode().asExpr().getUnderlyingValue() instanceof ImmediatelyInvokedFunctionExpr
}

predicate alwaysThrows(Function f) {
  exists(ReachableBasicBlock entry, DataFlow::Node throwNode |
    entry = f.getEntryBB() and
    throwNode.asExpr() = any(ThrowStmt t).getExpr() and
    entry.dominates(throwNode.getBasicBlock())
  )
}

/**
 * Holds if the last statement in the function is flagged by the js/useless-expression query.
 */
predicate lastStatementHasNoEffect(Function f) { hasNoEffect(f.getExit().getAPredecessor()) }

/**
 * Holds if `func` is a callee of `call`, and all possible callees of `call` never return a value.
 */
predicate callToVoidFunction(DataFlow::CallNode call, Function func) {
  not call.isIncomplete() and
  func = call.getACallee() and
  forall(Function f | f = call.getACallee() |
    returnsVoid(f) and not isStub(f) and not alwaysThrows(f)
  )
}

/**
 * Holds if `name` is the name of a method from `Array.prototype` or Lodash,
 * where that method takes a callback as parameter,
 * and the callback is expected to return a value.
 */
predicate hasNonVoidCallbackMethod(string name) {
  name =
    [
      "every", "filter", "find", "findIndex", "flatMap", "map", "reduce", "reduceRight", "some",
      "sort", "findLastIndex", "findLast"
    ]
}

DataFlow::SourceNode array(DataFlow::TypeTracker t) {
  t.start() and result instanceof DataFlow::ArrayCreationNode
  or
  exists(DataFlow::TypeTracker t2 | result = array(t2).track(t2, t))
}

DataFlow::SourceNode array() { result = array(DataFlow::TypeTracker::end()) }

/**
 * Holds if `call` is an Array or Lodash method accepting a callback `func`,
 * where the `call` expects a callback that returns an expression,
 * but `func` does not return a value.
 */
predicate voidArrayCallback(DataFlow::CallNode call, Function func) {
  hasNonVoidCallbackMethod(call.getCalleeName()) and
  exists(int index |
    index = min(int i | exists(call.getCallback(i))) and
    func = call.getCallback(index).getFunction()
  ) and
  returnsVoid(func) and
  not isStub(func) and
  not alwaysThrows(func) and
  (
    call.getReceiver().getALocalSource() = array()
    or
    call.getCalleeNode().getALocalSource() instanceof LodashUnderscore::Member
  )
}

predicate hasNonVoidReturnType(Function f) {
  exists(TypeAnnotation type | type = f.getReturnTypeAnnotation() | not type.isVoid())
}

from DataFlow::CallNode call, Function func, string name, string msg
where
  (
    callToVoidFunction(call, func) and
    msg = "the $@ does not return anything, yet the return value is used." and
    name = func.describe()
    or
    voidArrayCallback(call, func) and
    msg =
      "the $@ does not return anything, yet the return value from the call to " +
        call.getCalleeName() + " is used." and
    name = "callback function"
  ) and
  not benignContext(call.getEnclosingExpr()) and
  not lastStatementHasNoEffect(func) and
  // anonymous one-shot closure. Those are used in weird ways and we ignore them.
  not oneshotClosure(call) and
  not hasNonVoidReturnType(func) and
  not call.getEnclosingExpr() instanceof SuperCall
select call, msg, func, name
