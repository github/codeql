/**
 * @name Serialization check bypass
 * @description A write that looks like it may be bypassing runtime checks.
 * @kind problem
 * @id cs/serialization-check-bypass
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-20
 */

import semmle.code.csharp.serialization.Serialization
import semmle.code.csharp.controlflow.Guards
import semmle.code.csharp.dataflow.DataFlow

/**
 * The result is a write to the field `f`, assigning it the value
 * of variable `v` which was checked by the condition `check`.
 */
GuardedExpr checkedWrite(Field f, Variable v, IfStmt check) {
  result = v.getAnAccess() and
  result = f.getAnAssignedValue() and
  check.getCondition().getAChildExpr*() = result.getAGuard(_, _)
}

/**
 * The result is an unsafe write to the field `f`, where
 * there is no check performed within the (calling) scope of the method.
 */
pragma[nomagic]
Expr uncheckedWrite(Callable callable, Field f) {
  result = f.getAnAssignedValue() and
  result.getEnclosingCallable() = callable and
  not callable.calls*(checkedWrite(f, _, _).getEnclosingCallable()) and
  // Exclude object creations because they were not deserialized
  not exists(Expr src | DataFlow::localExprFlow(src, result) |
    src instanceof ObjectCreation or src.hasValue()
  )
}

from BinarySerializableType t, Field f, IfStmt check, Expr write, Expr unsafeWrite
where
  f = t.getASerializedField() and
  write = checkedWrite(f, t.getAConstructor().getAParameter(), check) and
  unsafeWrite = uncheckedWrite(t.getADeserializationCallback(), f)
select unsafeWrite, "This write to $@ may be circumventing a $@.", f, f.toString(), check, "check"
