/**
 * @name List all JVM method calls
 * @description Lists all invoke instructions and their targets
 * @kind table
 * @id jvm/list-calls
 */

import semmle.code.binary.ast.internal.JvmInstructions

from JvmInvoke invoke
select invoke.getEnclosingMethod().getFullyQualifiedName() as caller,
  invoke.getMnemonic() as invokeType, invoke.getCallTarget() as target,
  invoke.getNumberOfArguments() as argCount
