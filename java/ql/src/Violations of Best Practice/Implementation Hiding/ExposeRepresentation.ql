/**
 * @name Exposing internal representation
 * @description An object that accidentally exposes its internal representation may allow the
 *              object's fields to be modified in ways that the object is not prepared to handle.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/internal-representation-exposure
 * @tags reliability
 *       maintainability
 *       modularity
 *       external/cwe/cwe-485
 */

import java
import semmle.code.java.dataflow.DefUse

predicate relevantType(RefType t) {
  t instanceof Array
  or
  exists(RefType sup | sup = t.getAnAncestor().getSourceDeclaration() |
    sup.hasQualifiedName("java.util", "Map") or
    sup.hasQualifiedName("java.util", "Collection")
  )
}

predicate modifyMethod(Method m) {
  relevantType(m.getDeclaringType()) and
  (
    m.hasName("add") or
    m.hasName("addAll") or
    m.hasName("put") or
    m.hasName("putAll") or
    m.hasName("push") or
    m.hasName("pop") or
    m.hasName("remove") or
    m.hasName("removeAll") or
    m.hasName("clear") or
    m.hasName("set")
  )
}

predicate storesArray(Callable c, int i, Field f) {
  f.getDeclaringType() = c.getDeclaringType().getAnAncestor().getSourceDeclaration() and
  relevantType(f.getType()) and
  exists(Parameter p | p = c.getParameter(i) | f.getAnAssignedValue() = p.getAnAccess()) and
  not c.isStatic()
}

predicate returnsArray(Callable c, Field f) {
  f.getDeclaringType() = c.getDeclaringType().getAnAncestor().getSourceDeclaration() and
  relevantType(f.getType()) and
  exists(ReturnStmt rs | rs.getEnclosingCallable() = c and rs.getResult() = f.getAnAccess()) and
  not c.isStatic()
}

predicate mayWriteToArray(Expr modified) {
  writesToArray(modified)
  or
  // x = __y__; x[0] = 1;
  exists(AssignExpr e, LocalVariableDecl v | e.getDest() = v.getAnAccess() |
    modified = e.getSource() and
    mayWriteToArray(v.getAnAccess())
  )
  or
  // int[] x = __y__; x[0] = 1;
  exists(LocalVariableDeclExpr e, Variable v | e.getVariable() = v |
    modified = e.getInit() and
    mayWriteToArray(v.getAnAccess())
  )
  or
  // return __array__;    ...  method()[1] = 0
  exists(ReturnStmt rs | modified = rs.getResult() and relevantType(modified.getType()) |
    exists(Callable enclosing, MethodAccess ma |
      enclosing = rs.getEnclosingCallable() and ma.getMethod() = enclosing
    |
      mayWriteToArray(ma)
    )
  )
}

predicate writesToArray(Expr array) {
  relevantType(array.getType()) and
  (
    exists(Assignment a, ArrayAccess access | a.getDest() = access | access.getArray() = array)
    or
    exists(MethodAccess ma | ma.getQualifier() = array | modifyMethod(ma.getMethod()))
  )
}

VarAccess modificationAfter(VarAccess v) {
  mayWriteToArray(result) and
  useUsePair(v, result)
}

VarAccess varPassedInto(Callable c, int i) {
  exists(Call call | call.getCallee() = c | call.getArgument(i) = result)
}

predicate exposesByReturn(Callable c, Field f, Expr why, string whyText) {
  returnsArray(c, f) and
  exists(MethodAccess ma |
    ma.getMethod() = c and ma.getCompilationUnit() != c.getCompilationUnit()
  |
    mayWriteToArray(ma) and
    why = ma and
    whyText = "after this call to " + c.getName()
  )
}

predicate exposesByStore(Callable c, Field f, Expr why, string whyText) {
  exists(VarAccess v, int i |
    storesArray(c, i, f) and
    v = varPassedInto(c, i) and
    v.getCompilationUnit() != c.getCompilationUnit() and
    why = modificationAfter(v) and
    whyText = "through the variable " + v.getVariable().getName()
  )
}

from Callable c, Field f, Expr why, string whyText
where
  exposesByReturn(c, f, why, whyText) or
  exposesByStore(c, f, why, whyText)
select c,
  c.getName() + " exposes the internal representation stored in field " + f.getName() +
    ". The value may be modified $@.", why.getLocation(), whyText
