/**
 * Predicates that help detect potential non-cryptographic hash functions
 *
 * By themselves, non-cryptographic functions are common and not dangerous
 * These predicates are intended for helping detect non-cryptographic hashes that may be used
 * in a context that is not appropriate, or for detecting modified hash functions
 */

import csharp
private import DataFlow

predicate maybeANonCryptographicHash(
  Callable callable, Variable v, Expr xor, Expr mul, LoopStmt loop
) {
  callable = loop.getEnclosingCallable() and
  (
    maybeUsedInFnvFunction(v, xor, mul, loop) or
    maybeUsedInElfHashFunction(v, xor, mul, loop)
  )
}

/**
 * Holds if the arguments are used in a way that resembles a FNV hash function
 * where there is a loop statement `loop` where the variable `v` is used in an xor `xor` expression
 * followed by a multiplication `mul` expression.
 */
predicate maybeUsedInFnvFunction(Variable v, Operation xor, Operation mul, LoopStmt loop) {
  exists(Expr e1, Expr e2 |
    e1.getAChild*() = v.getAnAccess() and
    e2.getAChild*() = v.getAnAccess() and
    e1 = xor.getAnOperand() and
    e2 = mul.getAnOperand() and
    xor.getAControlFlowNode().getASuccessor*() = mul.getAControlFlowNode() and
    (xor instanceof AssignXorExpr or xor instanceof BitwiseXorExpr) and
    (mul instanceof AssignMulExpr or mul instanceof MulExpr)
  ) and
  loop.getAChild*() = mul.getEnclosingStmt() and
  loop.getAChild*() = xor.getEnclosingStmt()
}

/**
 * Holds if the arguments are used in a way that resembles an Elf-Hash hash function
 * where there is a loop statement `loop` where the variable `v` is used in an xor `xor` expression
 * followed by an addition `add` expression.
 */
private predicate maybeUsedInElfHashFunction(Variable v, Operation xor, Operation add, LoopStmt loop) {
  exists(
    Expr e1, Expr e2, AssignExpr addAssign, AssignExpr xorAssign, Operation notOp,
    AssignExpr notAssign
  |
    (add instanceof AddExpr or add instanceof AssignAddExpr) and
    e1.getAChild*() = add.getAnOperand() and
    e1 instanceof BinaryBitwiseOperation and
    e2 = e1.(BinaryBitwiseOperation).getLeftOperand() and
    v = addAssign.getTargetVariable() and
    addAssign.getAChild*() = add and
    (xor instanceof BitwiseXorExpr or xor instanceof AssignXorExpr) and
    addAssign.getAControlFlowNode().getASuccessor*() = xor.getAControlFlowNode() and
    xorAssign.getAChild*() = xor and
    v = xorAssign.getTargetVariable() and
    (notOp instanceof UnaryBitwiseOperation or notOp instanceof AssignBitwiseOperation) and
    xor.getAControlFlowNode().getASuccessor*() = notOp.getAControlFlowNode() and
    notAssign.getAChild*() = notOp and
    v = notAssign.getTargetVariable() and
    loop.getAChild*() = add.getEnclosingStmt() and
    loop.getAChild*() = xor.getEnclosingStmt()
  )
}

/**
 * Holds if the Callable is a function that behaves like a non-cryptographic hash
 * where the parameter `param` is likely the message to hash
 */
predicate isCallableAPotentialNonCryptographicHashFunction(Callable callable, Parameter param) {
  exists(Expr op1, Expr op2 |
    maybeANonCryptographicHash(callable, _, op1, op2, _) and
    callable.getAParameter() = param and
    exists(ParameterNode p, ExprNode n |
      p.getParameter() = param and
      localFlow(p, n) and
      n.getExpr() in [op1.(Operation).getAChild*(), op2.(Operation).getAChild*()]
    )
  )
}
