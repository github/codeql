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

import semmle.code.csharp.security.serialization.Serialization

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

from BinarySerializableType t, Field f, IfStmt check, Expr write, Expr unsafeWrite
where
  f = t.getASerializedField() and
  write = checkedWrite(f, t.getAConstructor().getAParameter(), check) and
  unsafeWrite = f.getAnAssignedValue() and
  t.getADeserializationCallback() = unsafeWrite.getEnclosingCallable() and
  not t.getADeserializationCallback().calls*(checkedWrite(f, _, _).getEnclosingCallable())
select unsafeWrite, "This write to $@ may be circumventing a $@.", f, f.toString(), check, "check"
