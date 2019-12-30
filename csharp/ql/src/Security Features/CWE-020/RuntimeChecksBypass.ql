/**
 * @name Serialization check bypass
 * @description A write that looks like it may be bypassing runtime checks.
 * @kind problem
 * @id cs/serialization-check-bypass
 * @problem.severity warning
 * @tags security
 *       external/cwe/cwe-20
 */

/*
 * consider: @precision medium
 */

import semmle.code.csharp.serialization.Serialization

/**
 * The result is a write to the field `f`, assigning it the value
 * of variable `v` which was checked by the condition `check`.
 */
Expr checkedWrite(Field f, Variable v, IfStmt check) {
  result = v.getAnAccess() and
  result = f.getAnAssignedValue() and
  check.getCondition() = v.getAnAccess().getParent*() and
  result.getAControlFlowNode() = check.getAControlFlowNode().getASuccessor*()
}

/**
 * The result is an unsafe write to the field `f`, where
 * there is no check performed within the (calling) scope of the method.
 */
Expr uncheckedWrite(Callable callable, Field f) {
  result = f.getAnAssignedValue() and
  result.getEnclosingCallable() = callable and
  not callable.calls*(checkedWrite(f, _, _).getEnclosingCallable())
}

from BinarySerializableType t, Field f, IfStmt check, Expr write, Expr unsafeWrite
where
  f = t.getASerializedField() and
  write = checkedWrite(f, t.getAConstructor().getAParameter(), check) and
  unsafeWrite = uncheckedWrite(t.getADeserializationCallback(), f)
select unsafeWrite, "This write to $@ may be circumventing a $@.", f, f.toString(), check, "check"
